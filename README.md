# Управление проектным отделом

## Архитектура

1. [Модель системы в нотации C4](architect/c4_model/1C_PDM_C4_Model.dsl)
2. [Используемые подсистемы БСП](architect/ssl_usage.md)

## Информация для контрибьюторов

### Правила установки версии конфигурации

- Версия конфигурации ведется в [стандартном формате компании 1С](https://its.1c.ru/db/v8std/content/483/hdoc): редакция.подредакция.версия.сборка
- Номер сборки необходимо повышать при каждом PR (кроме PR меняющих скрипты/тесты/документацию)
- Номер версии повышается при значительной доработке существующей функциональности или добавлении новой подсистемы
- Номер подредакции повышается при полной переработке архитектуры
- Версия так же меняется в модуле ОбновлениеИнформационнойБазыУПО для корректной работы в связке с БСП

> Релиз выпускается при повышении версии конфигурации

### Версия платформы и режим совместимости

> Разработка ведется на версии 8.3.25
> Режим совместимости 8.3.16

### Руководство контрибьютора

1. [Руководство по написанию юнит-тестов YaXUnit](https://github.com/firstBitSportivnaya/PSSL/blob/develop/docs/%D0%A0%D1%83%D0%BA%D0%BE%D0%B2%D0%BE%D0%B4%D1%81%D1%82%D0%B2%D0%BE%D0%9F%D0%BE%D0%9D%D0%B0%D0%BF%D0%B8%D1%81%D0%B0%D0%BD%D0%B8%D1%8E%D0%A2%D0%B5%D1%81%D1%82%D0%BE%D0%B2YAxUnit.md)