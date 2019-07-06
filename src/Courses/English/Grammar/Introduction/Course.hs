{-# LANGUAGE OverloadedStrings #-}

module Courses.English.Grammar.Introduction.Course (course) where

import Core

import Courses.English.Grammar.Introduction.Lessons

-- introduce djica alongside questions: "I want you to be happy" / "Do you want me to be happy?" / "What do you want?" / "Who wants you to be happy" / "Who do you want to be happy?"
-- TODO: remove the translations that make the least sense (in progress...)

-- Considerations
-- TODO: cleanup all tenses before canonicalization (translations with incorrect tenses will be accepted, but this is likely a small price to pay in order to accept correct translations including tenses)
-- TODO: also accept "ma'a" (and similar terms) whenever "mi" is accepted
-- TODO: consider accepting "su'u" whenever "nu" and "du'u" are accepted




-------- Tanru
-- useful gismu: sutra, pelxu
-- lo melbi prenu, lo sutra mlatu, lo sutra gerku, lo gleki prenu, lo melbi prenu, mi mutce gleki
-------- Questions
-- Are you talking about the donation? (lo ka dunda)
-- Who wants to talk to me?
-- Who do you think you are talking to? (?)


-- Reminder: from Lesson 4 onwards, mix propositions and questions


-------- Course
style :: CourseStyle
style = CourseStyle color1 iconUrl where
    -- Color1
    color1 = Just
        "#4c4c4c"
    -- Icon url
    iconUrl = Just
        -- Source: https://www.flaticon.com/free-icon/jigsaw_993723#term=jigsaw&page=1&position=3
        "https://image.flaticon.com/icons/svg/993/993723.svg"

        -- Source: https://www.flaticon.com/free-icon/jigsaw_993686
        --"https://image.flaticon.com/icons/svg/993/993686.svg"

        -- Source: https://www.flaticon.com/free-icon/puzzle_755205
        --"https://image.flaticon.com/icons/svg/755/755205.svg"

course :: CourseBuilder
course = createCourseBuilder title style lessons where
    title = "Introduction to Grammar"
    lessons = [lesson1, lesson2, lesson3, lesson4, lesson5, checkpoint1to5, lesson7, lesson8, lesson9, lesson10]