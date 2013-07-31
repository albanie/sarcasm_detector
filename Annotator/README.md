Annotator
=========

*An app for annotating tweets!*


Install
----------

This rails application is designed to evaluate humans ability to recognize sarcasm in tweets.  It is designed to work with ruby-1.9.3-p392 and rails 3.

To run this locally check which version of ruby you have with the following command:

    ruby -v

Anything after 1.9.3 should probably work fine.  If necessary, update/install ruby.  Next, check that you have an up to date version of rails (this was developed with 3.2.13) with:

    rails -v

Again, update/install rails if required.  Finally, simply clone or download the repo, cd into the root directory and run:

    rails server

By default, the app should now be running on localhost:3000.

---------

Information

Here is the information given to the user, which gives an overview of the purpose of the tool, together with instructions as to how it should be used. minus some of the necessary legalize required for a research study:

--------------
This study is being conducted as part of research into techniques to improve *sentiment analysis* on twitter data. 
Essentially, this involves collecting a large number of tweets from twitter and building a system that can be "trained" on some of these tweets to be able to decide whether or not a tweet is positive or negative.  This is the sort of thing that can be useful to companies who want to know how the public is reacting to their product releases.

For example, if people tweet: 

>  "The new iphone is powerful, but I hate how heavy it is #applegravity #Newtonwouldlikeit"

then by performing sentiment analysis, Apple can ascertain that there is a positive response to the iphone processor power, but a negative response to its weight.  This information (particularly when extracted from hundreds of thousands of tweets) forms a valuable source of customer feedback.  It can be performed on a far larger scale than a survery and often offers a truer reflection of the users opinion.

However, sarcasm makes this task very difficult.  It is comparatively simple to build a system that classifies the tweet from words that are associated with clearly positive or negative feelings (e.g  *powerful* and *heavy* in the tweet above).  However, consider the following tweet:

> "I just love the new Samsung. It's incredible. So, so fast. #sarcasm"

A system that isn't trained to deal with sarcasm will see *love*, *incredible* and *fast*, and classify the tweet as positive, which doesn't reflect the sentiment of the user at all!  In their raw form, tweets are a mass of unsorted snippets of information, mixed together without any structure.  The task of a classifer (the term given to such a system) is to separate this data into categories as accurately as possible.  To illustrate this concept, take a look at the diagram below and click 'Classify!' to see how the classifier aims to categorize the tweets:

As part of my research, I have designed a system that aims to achieve this separation by classifying tweets as positive, sarcastic or negative to deal with this problem of intended sentiment.  However, in order to test the effectiveness of the system, I need to compare it against humans.  The purpose of this study is establish a human benchmark for the difficulty of the task of deciding whether or not a tweet is sarcastic.

> Legal jargon about data storgage and the personal information of participants has been removed.

Instructions
-------------
You will be presented with a series of tweets, one at a time, together with other replies or tweets that were part of that conversation (if there were any).  The task is simply to note whether you believe the intended meaning of the original tweet was positive sarcastic or negative.  The tweets themselves have been made anonymous as far as possible - the username of the tweeter has been removed and any tweets directed at a specific user have had the name of that user replaced with @SomeUser. 

Some of the tweets my be badly formed or ambiguous.  In such cases, just give your best guess as to the intention of the original tweet author.  If they are completely unintelligble, there is an option to mark the tweet as 'gibberish'.  Please also note that some tweets may contain offensive language. 

There is no time limit in which to classify tweets.  There is no minimum or maximum number that you are required to classify.  However, as a guide, if you feel you are able to comfortably classify 200 tweets, this would be very useful for the purposes of the research.  In order to make the study more interesting, the more tweets that you classify, the more you will increase your 'level' as a participant, allowing you to unlock themed images.  This is purely to make the task more enjoyable. 
