#Пользователи
DepartmentHead = person "Руководитель отдела"
ProjectManager = person "Руководитель проекта"
Trainer = person "Ведущий обучения"
Employee = person "Сотрудник"

#Системы
1CPDM = softwareSystem "1С: Управление проектным отделом" {
    SubsysProjectDepartment = container "Учет проектных отделов" "" "Подсистема" "Подсистемы" {
        Cat_Offices = component "Офисы" "" "Справочник" "Справочники"         
        Cat_Departments = component "Отделы" "" "Справочник" "Справочники"
        Cat_Projects = component "Проекты" "" "Справочник" "Справочники"
        Cat_Employees = component "Сотрудники" "" "Справочник" "Справочники"
        Cat_Positions = component "Должности" "" "Справочник" "Справочники"
        Cat_Function = component "Позиции" "" "Справочник" "Справочники"
        Doc_PersonnelChange = component "Кадровые изменения" "" "Документ" "Документы"
        Enum_PersonnelChangeType = component "Виды кадровых изменений" "" "Перечисление" "Перечисления"
        InfoReg_PersonnelHistory = component "Кадровая информация" "" "Регистр сведений" "Регистры сведений"
    }
    SubsysTaskManagement = container "Управление задачами" "" "Подсистема" "Подсистемы" {
        Cat_JIRASettings = component "Настройки синхронизации с JIRA" "" "Справочник" "Справочники"
        Cat_Tasks = component "Задачи" "" "Справочник" "Справочники"
        Cat_Components = component "Компоненты" "" "Справочник" "Справочники"
        Enum_TasksType = component "Типы задач" "" "Перечисление" "Перечисления"
        Cat_TaskStatuses = component "Виды статусов задач" "" "Справочник" "Справочники"
        InfoReg_TaskStatuses = component "Статусы задач" "" "Регистр сведений" "Регистры сведений"
        InfoReg_TimeSheet = component "Учет рабочего времени" "" "Регистр сведений" "Регистры сведений"
    }
    SubsysEmployeeCompetencies = container "Учет компетенций и оценка сотрудников" "" "Подсистема" "Подсистемы" {
        Cat_ReviewTypes = component "Виды оценки сотрудников" "" "Справочник" "Справочники"
        Cat_Competencies = component "Компетенции" "" "Справочник" "Справочники"
        InfoReg_EmployeesCompetencies = component "Компетенции сотрудников" "" "Регистр сведений" "Регистры сведений"
        Enum_CompetenciesTypes = component "Типы компетенций" "" "Перечисление" "Перечисления"
        Enum_KnowledgeLevel = component "Уровени знания" "" "Перечисление" "Перечисления"
        Doc_Review = component "Оценка сотрудников" "" "Документ" "Документы"
        InfoReg_ReviewResult = component "Результаты оценки сотрудников" "" "Регистр сведений" "Регистры сведений"
    }
    SubsysEducation = container "Учет обучения" "" "Подсистема" "Подсистемы" {
        Cat_TrainingTopics = component "Темы обучений" "" "Справочник" "Справочники"
        Cat_Training = component "Обучения" "" "Справочник" "Справочники"
        Enum_TrainingStatuses = component "Статусы обучений" "" "Перечисление" "Перечисления"
        InfoReg_TrainingPlanning = component "Планирование обучений" "" "Регистр сведений" "Регистры сведений"
        InfoReg_TrainingTasks = component "Задачи обучений" "" "Регистр сведений" "Регистры сведений"
    }
    SubsysServiceObjects = container "Сервисные объекты" "" "Подсистема" "Подсистемы" {
        Cat_TelegramBots = component "Telegram боты" "" "Справочник" "Справочники"
        Cat_TelegramDistribution = component "Telegram рассылки" "" "Справочник" "Справочники"
        InfoReg_ObjectMapping = component "Соответствие объектов" "" "Регистр сведений" "Регистры сведений"
    }
    StandardSubsystemsLibrary = container "Библиотека стандартных подсистем" "" "Набор подсистем" "Подсистемы"
}
JIRA = softwareSystem "JIRA"
TG_Bot = softwareSystem "Telegram Bot"
OS_Web = softwareSystem "OScript.Web-App"
1CDO = softwareSystem "1С:ДО"