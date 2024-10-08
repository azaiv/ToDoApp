# To Do App

 <details>
    <summary style="font-size: 18px; font-weight: bold;">Тестовое задание</summary>
   
  ### Необходимо разработать простое приложение для ведения списка дел (ToDo List) с возможностью добавления, редактирования, удаления задач.

  #### 	Требования:


- ##### Список задач:
  - Отображение списка задач на главном экране.
  - Задача должна содержать название, описание, дату создания и статус (выполнена/не выполнена).
  - Возможность добавления новой задачи.
  - Возможность редактирования существующей задачи.
  - Возможность удаления задачи.


 - ##### Загрузка списка задач из dummyjson api:
   - [https://dummyjson.com/todos](https://dummyjson.com/todos). При первом запуске приложение должно загрузить список задач из указанного json api.
- Многопоточность
  - Обработка создания, загрузки, редактирования и удаления задач должна выполняться в фоновом потоке с использованием GCD или NSOperation.
  - Интерфейс не должен блокироваться при выполнении операций.


- ##### CoreData
  - Данные о задачах должны сохраняться в CoreData.
  -  Приложение должно корректно восстанавливать данные при повторном запуске.

#### 	Бонус:	
- Архитектура VIPER: Приложение должно быть построено с использованием архитектуры VIPER. Каждый модуль должен быть четко разделен на компоненты: View, Interactor, Presenter, Entity, Router.
- Используйте систему контроля версий GIT для разработки.
- Напишите юнит-тесты для основных компонентов приложения todos.json
 
</details>


## Первый запуск
При первом запуске приложения, должны загружаться данные с API. Если загрузить не удалось, парсим из файла который был предоставлен в тестовом задании.
Также все что загрузили из интернета или из файла, записывается в Core Data.
<details>
<summary>Видео</summary>
  
  ![001](https://github.com/user-attachments/assets/3a72c976-bbf1-421a-93d4-2173e55bc20b)


</details>

 ## Удаление задач
Удаление задач происходит нативным способом. Смахиваем справо налево.
<details>
<summary>Видео</summary>

  ![002](https://github.com/user-attachments/assets/51f4b0dd-fb75-4e9c-977d-c0b912983320)

</details>

## Создание задач
Для создании задач нужно нажать на кнопку "+" в навигейшене. Откроется модельный экран в котором можно добавить задачу. Для этого нужно придумать название задачи, описание является опциональным. Если задача не имеет название, кнопка добавления выключена. На модельном экране ячейки автоматически подстраиваются под размер контента.
<details>
<summary>Видео</summary>

  ![003](https://github.com/user-attachments/assets/41319e5a-1c37-4dac-80f6-fea60dfae4dc) ![004](https://github.com/user-attachments/assets/452c6924-fca7-4d22-98da-59a76f04b243)



</details>


## Редактирование задач
Редактирование задач происходит также нативно через свайп. Открывается модальный экран в котором можно вносить изменение в задачу.
<details>
<summary>Видео</summary>

  ![005](https://github.com/user-attachments/assets/07d66c74-9696-4927-ad5b-8e8739ebe2c1)

</details>

## Выполнение задач
Для того что изменить статус достачтоно нажать на кнопку справа в cтроке.
<details>
<summary>Видео</summary>

 ![006](https://github.com/user-attachments/assets/ebaef1b5-fbfe-492e-a09f-8ccbdca08d3e)


</details>

## Хранение
Задачи корректно восстанавливаются при повторном запуске.
<details>
<summary>Видео</summary>

![008](https://github.com/user-attachments/assets/ac8a341c-5999-45b5-8705-abc9c44cf871)



</details>


## Поиск
Для поиска задачи, нужно написать название задачи в строке поиска.
<details>
<summary>Видео</summary>

  ![007](https://github.com/user-attachments/assets/8a4ff4ad-74c6-4058-8d4b-70343fedb6ad)


</details>

## Локализация
Также в приложение добавлена локализация. (Английский / Русский)
<details>
<summary>Видео</summary>
  
  ![010](https://github.com/user-attachments/assets/e5b81815-02c9-4c6e-9abb-04f1ffd07f4e)
</details>








