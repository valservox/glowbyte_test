"""
Дана строка s: str и список слов dictionary: List[str].
Нужно найти слово максимальной длины из dictionary, которое можно получить удалением некоторого количества элементов из s. 
Если таких слов несколько, то нужно вернуть то, которое имеет минимальный лексиграфический порядок.

s = “abcpldpseplae”, dictionary = [‘ale’, ‘apple’, ‘monkey’, ‘sgfh’] -> ‘apple’’
"""

s = "abcpldpseplae"
dictionary = ["ale", "apple", "monkey", "sgfh","appla"]

def kind_of_scrable(input_string, word_list: list):

    found_words = []

    for i in word_list:

        search_from = 0
        const = True
    
        for j in i:

            if not const:
                continue

            if j in input_string[search_from:]:
                
                search_from = i.index(j) + 1

            else:
                const = False

        if not const:
            continue

        found_words.append(i)

    max_word_len = len(max(found_words, key=len))

    return min(list(filter(lambda x: len(x) == max_word_len, found_words)))

print(kind_of_scrable(s,dictionary))