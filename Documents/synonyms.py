#Mila Hoogstraat
#Assignment 5(synonyms)
#UCID : 30055558
#Date: December 3rd, 2017







#Semantic Similarity: starter code

#Author: Michael Guerzhoy. Last modified: Nov. 18, 2015.


import math
import time


def norm(vec):
    '''Return the norm of a vector stored as a dictionary,
    as described in the handout for Project 3.
    '''
    
    sum_of_squares = 0.0  # floating point to handle large numbers
    for x in vec:
        sum_of_squares += vec[x] * vec[x]
    
    return math.sqrt(sum_of_squares)

#The parameters represent the keys 
def cosine_similarity(vec1, vec2):
    #the following code is from the intermediate version starter handout code 
    #from http://nifty.stanford.edu/2017/guerzhoy-SAT-synonyms/ (synonyms.py)
    
    dot_product = 0.0  # floating point to handle large numbers
    for x in vec1:
        if x in vec2:
            dot_product += vec1[x] * vec2[x]
    
    return dot_product / (norm(vec1) * norm(vec2))
    pass

#For each word in each sentence, the function tests them and creates a new
#dictionary for each word within its own dictionary. For each inner dicitonary,
#if the word is not already in the dictionary, its count increases by one for
#each time it appears in a sentence.
def build_semantic_descriptors(sentences):
#sets an empty dictionary
    d={}
    for i in sentences: 
        for w in i:
           #creates a new nested dictionary for each word in a sentence
            if w not in d:
                    d[w]={}
      
    for i in sentences:
                   
        for w in i:
            #check the words again to make sure word is not already in
            #dictionary before counting
    
                for k in i:
                    if k!=w:
                      if d[w].get(k) == None:
                        d[w][k]=1
                      elif k in d[w]:   
                        d[w][k]+=1
                        
    return(d)
   
#This function builds a dictionary from a file by splitting it at certain
# punctuation marks, and removing none alphabetical characters.
# We create a new nested list by appending each list fragment to an empty list
# (text). Once this nested list is created, it is passed as a parameter into
#the build_semantic_descriptors function.
#Filenames represents the name of the file
def build_semantic_descriptors_from_files(filenames):
    take_out = ("_","--",",",":",";","'","”",",","\n","“","-")
    end_sentence = ("?","!",".")

    text=[]
    for excerpt in filenames:
        file = open(excerpt, "r", encoding = "utf-8")
        #used the .lower function so that an upper case and lower case of a 
        #letter do not count as different words
        file = file.read().lower()

        for i in end_sentence:
            if i in file:
                file = file.replace(i,"***")
        
        for i in take_out:
            if i in file or not i.isalpha():
                file = file.replace(i," ")
        file = file.split("***")
        for i in file:
            
            i = i.split()
            text.append(i)

    new_dictionary = build_semantic_descriptors(text)
    return new_dictionary
 #Word represents the word that the program is looking for the closest synonym
 #for. Choices represent the words that we are looking for the closest synonym
 #from.Semantic_descriptors represents the dictionaries built from the file.
 #Simlarity_fn represents the function used to calculate the similarity between
 #the words.(cosine_similarity)
def most_similar_word(word, choices, semantic_descriptors, similarity_fn):
#similarity_fn takes in two sparse vectors and returns a float
#min index function = smallest index returned in case of a tie 
#default semantic similarity = -1
    
    default_similarity = 0.0
    for choice in choices:
        try:
            vec1=semantic_descriptors[word]
            vec2=semantic_descriptors[choice]
            simil = cosine_similarity(vec1,vec2)
            
        except KeyError:
            #sets the default similarity value to -1 in the case of a KeyError
            
            simil = -1
            #takes the element (choice) with the
             #smallest index when a tie occurs between similarities
            word_returned=choices[0]
        if  simil > default_similarity:
            default_similarity = simil 
            word_returned = choice
            
    return word_returned 

 #Filename is the name of the file used for the words and choices 
 #Semantic_descriptors are the dictionaries we created
 #Similarity_fn is the function(cosine_simlarity in this case) 
 #used to calculate the most similar word from the list of choices from the
#file   

def run_similarity_test(filename, semantic_descriptors, similarity_fn):

    #setting initial count values 
    right_answers_count = 0 
    questions = 0 
    file = open(filename,"r")
    #reading through each line in the text file, one by one.
    for line in file:
        line.replace('\n',"")
        line = line.split()
        #setting values for each word in every line in the text file
        w = line[0]
        choices = line[2:]
        a = line[1]
        #every line is a new question
        questions += 1
        #if the chosen word from the most_similar_word function is the same
        #as the first word in each line in the text file,
        #this is the correct answer, and therefore the right_answers_count
        #increases by 1 each time.

        if most_similar_word(w,choices,semantic_descriptors,similarity_fn)==a:
            
            right_answers_count += 1 
    #calculating accuracy based on how many answers were correct 
    accuracy = (right_answers_count/questions)*100
    accuracy = str(round(accuracy,1))
    return accuracy

run_similarity_test('test.txt', build_semantic_descriptors_from_files(['Proust.txt','Tolstoy.txt']),cosine_similarity)


