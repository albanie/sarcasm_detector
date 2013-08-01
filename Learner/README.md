Learner
---------------

This folder contains the base scripts for running machine learning algorithms over the data.  
Three algorithms are used:

* Naive Bayes
* Logistic Regression 
* Support Vector Machines

Each script takes a csv file as input.  The features used to train the algorithms are easily configurable.  Possible feature choices include:

* word unigrams/bigrams/trigrams or a combination of these
* char ngrams
* choice of stopwords
* use of term frequency-inverse document frequency transformations of feature vectors

Adjusting the ratio of training data/test data is achieved through altering the     train_ratio     paramter in the script.

EchoEncoder
---------------

The EchoEncoder requires a sophisticated training process.  To run the EchoEncoder, run the three scripts in order.

EchoEncoder operates by splitting the data into three parts:

* 50% pre-training set
* 10% training set
* 40% test set

A Naive Bayes classifier is trained on the pre-training set.  This is used to classify both the tweets and replies in the training set and test set.  It outputs a string representation of this classification, known as an echo string.  For example, for a tweet that is classified as positive with two negative replies and three sarcastic replies, it outputs:

    P_N_N_S_S_S

A new file is created consisting of the labels of the original tweets together with these echo strings generated for the training set and the test set.  A second Naive Bayes classifier is then trained on the echo strings of the training set and used to predict the classes of the test set.