# This script is run as the first part of the EchoEncoder algorithm.
# It trains a Naive Bayes classifier on the pre_training set and uses
# it to create echo strings for the training set.

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

with open('ShuffledDataB.csv', 'rb') as csvfile:
    tweetReader = csv.reader(csvfile, quotechar='|')
    for row in tweetReader:
        x.append(row)

categories = []
data = []
replies_1 = []
replies_2 = []
replies_3 = []
replies_4 = []
replies_5 = []
for row in x:
    categories.append(row[0])
    data.append(row[1])
    replies_1.append(row[2])
    replies_2.append(row[3])
    replies_3.append(row[4])
    replies_4.append(row[5])
    replies_5.append(row[6])

p_train = 0.5
train = 0.1
test = 0.4

# <codecell>

pre_train_index = int(round(len(x)*p_train))
train_index = int(round(pre_train_index + len(x)*train))

# <codecell>

categories = []
data = []
replies_1 = []
replies_2 = []
replies_3 = []
replies_4 = []
replies_5 = []
for row in x:
    categories.append(row[0])
    data.append(row[1] + ' ' + row[2])
    replies_1.append(row[2])
    replies_2.append(row[3])
    replies_3.append(row[4])
    replies_4.append(row[5])
    replies_5.append(row[6])

# Set the ratio of pre_training data and training data
pre_train_ratio = 0.5
train_ratio = 0.1
pre_train_index = int(round(len(x)*p_train))
train_index = int(round(pre_train_index + len(x)*train))

# Split the data according to these ratios
pre_training_data = data[:pre_train_index]
training_data = data[pre_train_index:train_index]
training_replies_1 = replies_1[pre_train_index:train_index]
training_replies_2 = replies_2[pre_train_index:train_index]
training_replies_3 = replies_2[pre_train_index:train_index]
training_replies_4 = replies_2[pre_train_index:train_index]
training_replies_5 = replies_2[pre_train_index:train_index]

pre_training_categories = categories[:pre_train_index]
training_categories = categories[pre_train_index:train_index]


# Construct a feature vector containing counts of unigram and bigram 
# word occurence counts. 
count_vect = eature_extraction.text.CountVectorizer(stop_words='english', ngram_range=(1,2))
X_pre_train_counts = count_vect.fit_transform(pre_training_data)
X_train_counts = count_vect.transform(training_data)



# Transform the feature vectors into term frequency-inverse document 
# frequency counts.
tfidf_transformer_train = feature_extraction.text.TfidfTransformer()
X_train_tfidf = tfidf_transformer_train.fit_transform(X_train_counts)

tfidf_transformer = feature_extraction.text.TfidfTransformer()
X_pre_train_tfidf = tfidf_transformer.fit_transform(X_pre_train_counts)


digit_pre_training_categories = []
for label in pre_training_categories:
    if label == 'sarcastic':
        digit_pre_training_categories.append(0)
    elif label == 'negative':
        digit_pre_training_categories.append(1)
    else:
        digit_pre_training_categories.append(2)

digit_training_categories = []
for label in training_categories:
    if label == 'sarcastic':
        digit_training_categories.append(0)
    elif label == 'negative':
        digit_training_categories.append(1)
    else:
        digit_training_categories.append(2)

# Train a classifier using Multinomial Naive Bayes on the pre-training set
clf = MultinomialNB().fit(X_pre_train_tfidf, digit_pre_training_categories)

# Transform the replies into feature vectors consisting of word counts
X_test_counts = count_vect.transform(test_data)
X_reply_1_train_counts = count_vect.transform(training_replies_1)
X_reply_2_train_counts = count_vect.transform(training_replies_2)
X_reply_3_train_counts = count_vect.transform(training_replies_3)
X_reply_4_train_counts = count_vect.transform(training_replies_4)
X_reply_5_train_counts = count_vect.transform(training_replies_5)

# Convert these word coumts into term frequency-inverse document frequencies
X_test_tfidf = tfidf_transformer.transform(X_test_counts)
X_reply_1_train_tfidf = tfidf_transformer.transform(X_reply_1_train_counts)
X_reply_2_train_tfidf = tfidf_transformer.transform(X_reply_2_train_counts)
X_reply_3_train_tfidf = tfidf_transformer.transform(X_reply_3_train_counts)
X_reply_4_train_tfidf = tfidf_transformer.transform(X_reply_4_train_counts)
X_reply_5_train_tfidf = tfidf_transformer.transform(X_reply_5_train_counts)


# Print out the cross validation scores for the set
cvscores = cross_validation.cross_val_score(clf, X_pre_train_tfidf, np.array(digit_pre_training_categories), cv=10, n_jobs=1)
print "Mean cross validation score:"
print
mean = sum(cvscores) / len(cvscores)
print mean
print

print("Detailed classification report:")
print
print("The model is trained on the full development set.")
print("The scores are computed on the full evaluation set.")
y_true = digit_training_categories
reply_1_pred = clf.predict(X_reply_1_train_tfidf)
reply_2_pred = clf.predict(X_reply_2_train_tfidf)
reply_3_pred = clf.predict(X_reply_3_train_tfidf)
reply_4_pred = clf.predict(X_reply_4_train_tfidf)
reply_5_pred = clf.predict(X_reply_5_train_tfidf)
y_pred = clf.predict(X_train_tfidf)
print(classification_report(y_true, y_pred))


# Zip up each of the predicted labels for the replies into an array
labels_1 = []
labels_2 = []
labels_3 = []
labels_4 = []
labels_5 = []

zipped1 = zip(reply_1_pred, replies_1)
for x,y in zipped1:
    if y == '':
        x = 3
    labels_1.append(x)
    
zipped2 = zip(reply_2_pred, replies_2)
for x,y in zipped2:
    if y == '':
        x = 3
    labels_2.append(x)
    
zipped3 = zip(reply_3_pred, replies_3)
for x,y in zipped3:
    if y == '':
        x = 3
    labels_3.append(x)
    
zipped4 = zip(reply_4_pred, replies_4)
for x,y in zipped4:
    if y == '':
        x = 3
    labels_4.append(x)
    
zipped5 = zip(reply_5_pred, replies_5)
for x,y in zipped5:
    if y == '':
        x = 3
    labels_5.append(x)

# Create a tuple consisting of the required labels
quin_labels = []
zippedQuin = zip(y_pred, labels_1, labels_2, labels_3, labels_4, labels_5)

# Define functions to transform the labels back to an appropriate string form
def transform_label(x):
    result = ''
    if   (x == 0):
        result = 'S'
    elif (x == 1):
        result = 'N'
    elif (x == 2):
        result = 'P'
    return result

def transform_reply(x):
    result = ''
    if   (x == 0):
        result = '_S'
    elif (x == 1):
        result = '_N'
    elif (x == 2):
        result = '_P'
    else:
        result = '_B'
    return result

# Perform the transformation
for a,b,c,d,e,f in zippedQuin:
    result = transform_label(a)
    result += transform_reply(b)
    result += transform_reply(c)
    result += transform_reply(d)
    result += transform_reply(e)
    result += transform_reply(f)
    quin_labels.append(result)
print quin_labels

training_zip = zip(training_categories, quin_labels)

# Write the echo strings and labels into the shuffled echo strings file 
with open('EchoStrings.csv', 'wb') as csvfile:
    tweetWriter = csv.writer(csvfile, delimiter=',', quotechar='|', quoting=csv.QUOTE_ALL)
    for row in training_zip:
        tweetWriter.writerow(row)

