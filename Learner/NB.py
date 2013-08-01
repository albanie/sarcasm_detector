import csv
import random
import scipy
import numpy as np
import pylab as pl
from sklearn import metrics
from sklearn import cross_validation
from sklearn import grid_search
from sklearn import feature_extraction
from sklearn.naive_bayes import MultinomialNB

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

# Train a classifier using Multinomial Naive Bayes
clf = MultinomialNB().fit(X_train_tfidf, digit_training_categories)

# Fit the test set to the feature vector established on the training set
from sklearn.feature_extraction.text import CountVectorizer
X_test_counts = count_vect.transform(test_data)
X_test_tfidf = tfidf_transformer.transform(X_test_counts)

cvscores = cross_validation.cross_val_score(clf, X_train_tfidf, np.array(digit_training_categories), cv=10, n_jobs=1)
print "Mean cross validation score:"
print
mean = sum(cvscores) / len(cvscores)
print mean
print

print("Detailed classification report:")
print
print("The model is trained on the full development set.")
print("The scores are computed on the full evaluation set.")
y_true = digit_test_categories
y_pred = clf.predict(X_test_tfidf)
print(classification_report(y_true, y_pred))

cm = metrics.confusion_matrix(y_true, y_pred)
print 'confusion matrix:'
print '     predicted column'
print '          (S)  (N)  (P)'
print 'truth:    S     S    S'
print 'truth:    N     N    N'
print 'truth:    P     P    P'
print
print  cm
