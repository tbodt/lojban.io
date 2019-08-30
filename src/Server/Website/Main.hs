{-# LANGUAGE OverloadedStrings #-}

module Server.Website.Main
( handleHome
, handleGrammar
, handleVocabulary
, handleResources
) where

import Core
import Serializer (exerciseToJSON, validateExerciseAnswer)
import qualified Courses.English.Grammar.Introduction.Course
import qualified Courses.English.Grammar.Crash.Course
import qualified Courses.English.Vocabulary.Attitudinals.Course
import qualified Courses.English.Vocabulary.Brivla.Course
import Server.Util (forceSlash, getBody)
import Server.Website.Core
import Server.Website.Home (displayHome)
import Server.Website.Grammar (displayGrammarHome)
import Server.Website.Vocabulary (displayVocabularyHome)
import Server.Website.Resources (displayResourcesHome)
import Server.Website.Course (displayCourseHome)
import Server.Website.Lesson (displayLessonHome, displayLessonExercise)
import Control.Monad (msum, guard)
import Control.Monad.IO.Class (liftIO)
import System.Random (newStdGen, mkStdGen)
import qualified Data.Aeson as A
import Happstack.Server

-- TODO: consider adding breadcrumbs (https://getbootstrap.com/docs/4.0/components/breadcrumb/)

-- * Handlers
handleHome :: ServerPart Response
handleHome = ok . toResponse $ displayHome

handleGrammar :: ServerPart Response
handleGrammar = msum
    [ forceSlash . ok . toResponse $ displayGrammarHome
    , dir "introduction" $ handleCourse TopbarGrammar Courses.English.Grammar.Introduction.Course.course
    , dir "crash" $ handleCourse TopbarGrammar Courses.English.Grammar.Crash.Course.course
    ]

handleVocabulary :: ServerPart Response
handleVocabulary = msum
    [ forceSlash . ok . toResponse $ displayVocabularyHome
    , dir "attitudinals" $ handleCourse TopbarVocabulary Courses.English.Vocabulary.Attitudinals.Course.course
    , dir "brivla" $ handleCourse TopbarVocabulary Courses.English.Vocabulary.Brivla.Course.course
    ]

handleResources :: ServerPart Response
handleResources = msum
    [ forceSlash . ok . toResponse $ displayResourcesHome
    ]

handleCourse :: TopbarCategory -> Course -> ServerPart Response
handleCourse topbarCategory course =
    let lessons = courseLessons course
    in msum
        [ forceSlash . ok . toResponse . displayCourseHome topbarCategory $ course
        , path $ \n -> (guard $ 1 <= n && n <= (length lessons)) >> (handleLesson topbarCategory course n)
        ]

handleLesson :: TopbarCategory -> Course -> Int -> ServerPart Response
handleLesson topbarCategory course lessonNumber = msum
    [ forceSlash . ok . toResponse $ displayLessonHome topbarCategory course lessonNumber
    , dir "exercises" $ msum
        [ forceSlash . ok . toResponse $ displayLessonExercise topbarCategory course lessonNumber
        , path $ \n ->
            let
                lesson = (courseLessons course) !! (lessonNumber - 1)
                exercise = lessonExercises lesson (mkStdGen n)
            in msum
                [ dir "get" $ (liftIO $ newStdGen) >>= ok . toResponse . A.encode . exerciseToJSON exercise
                , dir "submit" $ getBody >>= \body -> ok . toResponse . A.encode . A.object $
                    case validateExerciseAnswer exercise body of
                        Nothing -> [("success", A.Bool False)]
                        Just data' -> [("success", A.Bool True), ("data", data')]
                ]
        ]
    ]