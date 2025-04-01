workspace "1С:УПО" "Модель C4 для конфигурации 1С: Управление проектным отделом" {

    model {
    
        !include model/main.dsl

        # Взаимодействия уровня системного контекста
        DepartmentHead -> 1CPDM "Ведёт данные по отделу"
        DepartmentHead -> 1CDO "Смотрит данные по учету времени и себестоимости"
        DepartmentHead -> OS_Web "Смотрит отчеты"
        DepartmentHead -> TG_Bot "Взаимодействует с ботом"
        ProjectManager -> OS_Web "Смотрит отчеты"
        ProjectManager -> 1CDO "Смотрит данные по себестоимости"
        ProjectManager -> TG_Bot "Взаимодействует с ботом"
        Trainer -> 1CPDM "Вводит данные по обучению"
        Employee -> JIRA "Ведет учет"
        Employee -> TG_Bot "Взаимодействует с ботом"
        Employee -> 1CPDM "Смотрит информацию по обучениям"
        1CPDM -> JIRA "Получает информацию по задачам и времени"
        1CPDM -> TG_Bot "Передает и получает информацию от бота"
        OS_Web -> 1CPDM "Использует http-сервисы для визуализации данных"
        1CDO -> 1CPDM "Получает информацию по затратам времени"
        
        # Взаимодействие уровня контейнеров (подсистем)
        #DepartmentHead -> SubsysProjectDepartment "Вводит данные по отделу"
        #DepartmentHead -> SubsysEmployeeCompetencies "Вводит данные по компетенциям"
        #DepartmentHead -> SubsysEducation "Вводит данные по обучениям"
        SubsysProjectDepartment -> SubsysEmployeeCompetencies "Использует информацию по сотрудникам"
        SubsysProjectDepartment -> SubsysEducation "Использует информацию по сотрудникам"
        SubsysProjectDepartment -> SubsysTaskManagement "Использует информацию по проектам"
        SubsysTaskManagement -> SubsysServiceObjects "Заполняет ДО на основании JIRA"

        # Взаимодействие уровня компонентов (объектов)

        ## Подсистема Учет проектных отделов
        #DepartmentHead -> Doc_PersonnelChange "Вводит кадровую информацию"
        Cat_Offices -> Cat_Departments "Принадлежит офису"
        Cat_Departments -> Cat_Projects "Принадлежит отделу"
        Doc_PersonnelChange -> InfoReg_PersonnelHistory "Записывает информацию по кадровым изменениям" 
        Enum_PersonnelChangeType -> Doc_PersonnelChange "Определяет вид кадрового события"
        Cat_Employees -> Doc_PersonnelChange "Ссылается на сотрудников"
        Cat_Projects -> Doc_PersonnelChange "Ссылается на проекты"
        Cat_Positions -> Doc_PersonnelChange "Ссылается на должности сотрудников"
        Cat_Function -> Doc_PersonnelChange "Ссылается на позиции сотрудников"

        ## Подсистема Управление задачами
        JIRA -> Cat_JIRASettings "Загрузка задач и НСИ"
        Cat_JIRASettings -> Cat_Tasks "Хранит настройки JIRA по проектам"
        Enum_TasksType -> Cat_Tasks "Определяет тип задачи"
        Cat_Components -> Cat_Tasks "Определяет аналитику задачи"
        Cat_Tasks -> InfoReg_TaskStatuses "Хранит информацию о статусах"
        Cat_TaskStatuses -> InfoReg_TaskStatuses "Использует вид статусов"
        Cat_Tasks -> InfoReg_TimeSheet "Хранит информацию о рабочем времени"
        Cat_Tasks -> InfoReg_ObjectMapping "Использует мэппинг для передачи в ДО"

        ### Подсистема Сервисные объекты
        1CDO -> InfoReg_ObjectMapping "Получает мэппинг данных из JIRA к данным в 1С:ДО"
        Cat_TelegramBots -> InfoReg_ObjectMapping "Получает мэппинг чатов из Telegram к системным объектам"
        Cat_TelegramBots -> Cat_TelegramDistribution "Использует данные для рассылки"

        ## Подсистема Учет компетенций и оценка сотрудников
        Enum_KnowledgeLevel -> InfoReg_EmployeesCompetencies "Определяет уровень знания компетенции"
        Enum_CompetenciesTypes -> Cat_Competencies "Определяет тип компетенции"
        Cat_Competencies -> Cat_ReviewTypes "Используемые компетенции"
        Cat_ReviewTypes -> Doc_Review "Определяет список оцениваемых компетенций"
        Doc_Review -> InfoReg_ReviewResult "Хранит результаты оценки сотрудников"
        InfoReg_ReviewResult -> InfoReg_EmployeesCompetencies "Влияет на расчет оценки компетенции сотрудника"
        InfoReg_TimeSheet -> InfoReg_EmployeesCompetencies "Влияет на расчет оценки компетенции сотрудника"
        Cat_Training -> InfoReg_EmployeesCompetencies "Влияет на расчет оценки компетенции сотрудника"
        TG_Bot -> Doc_Review "Автоматически создает документ Оценка сотрудников"
        
        ## Подсистема Учет обучения
        TG_Bot -> InfoReg_TrainingPlanning "Предложение тем, плановых дат и голосование по темам"
        InfoReg_TrainingPlanning -> Cat_Training "Предоставляет данные о планах обучений"
        Cat_TrainingTopics -> Cat_Training "Определяет темы обучений"
        Enum_TrainingStatuses -> Cat_Training "Определяет статус обучения"
        Cat_Training -> InfoReg_TrainingTasks "Использует для связи с задачами Jira"
    }
    
    views {

        systemlandscape "SystemLandscape" {
            include *
            autolayout lr
        }
    
        systemContext 1CPDM {
            include *
            autolayout lr
        }

        container 1CPDM {
            include *
            autolayout lr
        }

        component SubsysProjectDepartment PD "Подсистема Учет проектных отделов" {
            include *
            autoLayout lr
        }
        
        component SubsysTaskManagement TM "Подсистема Управление задачами" {
            include *
            autoLayout lr
        }

        component SubsysServiceObjects SO "Подсистема Сервисные объекты" {
            include *
            autoLayout lr
        }

        component SubsysEmployeeCompetencies ECE "Подсистема Учет компетенций и оценка сотрудников" {
            include *
            autoLayout lr
        }

        component SubsysEducation EM "Подсистема Учет обучений" {
            include *
            autoLayout lr
        }

        styles {
            !include views/style.dsl    
        }

        themes https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json
    }
}