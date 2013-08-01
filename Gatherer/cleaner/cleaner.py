# This script forms the first part of preprocessing by subjecting each of the raw 
# tweets to a language test to ensure that it is fit for analysis.  The tweets may 
# not be in English.  Morevoer, many words used in tweets are abbreviations not present 
# in the dictionary, so the test cannot be too strict. To pass the test, a fifth of
# all words present in a particular tweet must match the dictionary.

import csv
import numpy as np
import random
import scipy
import enchant
import re

# Array to hold the contents the CSV file
x = []

# Load raw tweets
with open('RawData.csv', 'rU') as csvfile:
    tweetReader = csv.reader(csvfile, quotechar='|')
    for row in tweetReader:
        x.append(row)

# Instantiate a dictionary based on US English
d = enchant.Dict("en-US")

# Iterate over the tweets, subjecting each to the criteria outlined in the header
with open('CleanData.csv', 'wb') as csvfile:
    tweetwriter = csv.writer(csvfile, delimiter=',', quotechar='|', quoting=csv.QUOTE_ALL)
    data = []
    passing = 0
    total = 0
    for row in x:
        for token in str.split(row[1]):
             if re.match (r'[\x80-\xff]', token):
                 print 'appearance of hex string in tweet'
             else:
                 if (d.check(token) == True):
                     total +=1
                 else:
                     total+=0
        if total > len(str.split(row[1]))//5:
            passing +=1
            tweetwriter.writerow(row)
        else:
            passing +=0
        total = 0