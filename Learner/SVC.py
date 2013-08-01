import csv
import random
import scipy
import numpy as np
import pylab as pl
from sklearn import metrics
from sklearn import cross_validation
from sklearn import grid_search
from sklearn import feature_extraction
from sklearn import svm

# Array to hold the contents the CSV file
x = []

with open('ShuffledData.csv', 'rb') as csvfile:
    tweetReader = csv.reader(csvfile, quotechar='|')
    for row in tweetReader:
        x.append(row)

categories = []
data = []
for row in x:
    categories.append(row[0])
    data.append(row[1])

# Split the data set into two parts: training and testing
training_data = data[:9255]
test_data = data[9255:]
training_categories = categories[:9255]
test_categories = categories[9255:]

# Construct a feature vector containing counts of word occurences 

count_vect = feature_extraction.text.CountVectorizer(stop_words='english')
X_train_counts = count_vect.fit_transform(training_data)

# Convert the word counts into term frequency-inverse document frequency counts

tf_transformer = feature_extraction.text.TfidfTransformer(use_idf=False).fit(X_train_counts)
X_train_tf = tf_transformer.transform(X_train_counts)
tfidf_transformer = feature_extraction.text.TfidfTransformer()
X_train_tfidf = tfidf_transformer.fit_transform(X_train_counts)

# In order to train a support vector machine algorithm, we must convert the categories to digits
digit_test_categories = []
for label in test_categories:
    if label == 'sarcastic':
        digit_test_categories.append(0)
    elif label == 'negative':
        digit_test_categories.append(1)
    else:
        digit_test_categories.append(2)

digit_training_categories = []
for label in training_categories:
    if label == 'sarcastic':
        digit_training_categories.append(0)
    elif label == 'negative':
        digit_training_categories.append(1)
    else:
        digit_training_categories.append(2)

# Set the parameters that will be involved in the grid search SVM model by cross validation
tuned_parameters = [{'kernel': ['rbf'], 'gamma': [1e-3, 1e-4],
                     'C': [1, 10, 100, 1000]},
                    {'kernel': ['linear'], 'C': [1, 10, 100, 1000]}]
score_types = ['precision', 'recall']

for score in score_types:
    print ('Tuning hyper-parameters for %s' % score)

# The grid search is applied to tune the model to give the best performance      
clf = grid_search.GridSearchCV(svm.SVC(C=1), tuned_parameters, cv=10, scoring=score)

# Train the model
clf.fit(X_train_tfidf, digit_training_categories)

# Fit the test set to the feature vector established on the training set
from sklearn.feature_extraction.text import CountVectorizer
X_test_counts = count_vect.transform(test_data)
X_test_tfidf = tfidf_transformer.transform(X_test_counts)

print("Best parameters set found on development set:")
print
print(clf.best_estimator_)
print
print("Grid scores on development set:")
print
for params, mean_score, scores in clf.cv_scores_:
    print("%0.4f (+/-%0.04f) for %r"
              % (mean_score, scores.std() / 2, params))
print
print "Best score:"
print clf.best_score_

print "Grid scores:"
print clf.cv_scores_

print("Detailed classification report:")
print
print("The model is trained on the full development set.")
print("The scores are computed on the full evaluation set.")
y_true = digit_test_categories
y_pred = clf.predict(X_test_tfidf)
print(metrics.classification_report(y_true, y_pred))

cm = metrics.confusion_matrix(y_true, y_pred)
print 'confusion matrix:'
print '     predicted column'
print '          (S)  (N)  (P)'
print 'truth:    S     S    S'
print 'truth:    N     N    N'
print 'truth:    P     P    P'
print
print  cm
