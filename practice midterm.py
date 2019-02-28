def remove_bracket(sentence):
    count = 0
    
    for i in sentence:
            if i =="(":
                left_bracket = count
            elif i == ")":
                right_bracket = count
            count = count + 1
       

    new_sentence= sentence[0:left_bracket] +sentence[right_bracket+1:len(sentence)]
    return new_sentence



print(remove_bracket("The falling leaves drift by the window (the autumn leaves of red and gold)"))
