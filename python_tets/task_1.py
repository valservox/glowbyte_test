"""
Дан список: [1,3,1,2,4,1,2,13].

Нужно преобразовать его в список из элементов, которые встречаемся в нем не более 2-х раз. 
Каждое третье и последующее вхождение из него убрать. 
Исходный порядок должен быть сохранен.
"""

task = [1, 3, 1, 2, 4, 1, 2, 13]

def delete_after(input_list,n):
    
    counter_dict = {i: 0 for i in set(input_list)}

    new_list = []

    for i in input_list:

        counter_dict[i] += 1

        if counter_dict[i] <= n:
            new_list.append(i)

    return new_list

print(*delete_after(task,2))