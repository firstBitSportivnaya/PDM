﻿#Область ПрограммныйИнтерфейс

// Функция - Получить структуру регистрации рабочего времени
// 
// Возвращаемое значение:
//  СтруктураДанных - Структура - Структура с данными для заполнения
//
Функция ПолучитьСтруктуруРегистрацииРабочегоВремени() Экспорт
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("Дата", "");
	СтруктураДанных.Вставить("Номер", "");
	СтруктураДанных.Вставить("Ответственный", Пользователи.ТекущийПользователь());
	СтруктураДанных.Вставить("Комментарий", "");
	РабочееВремя = Новый ТаблицаЗначений;
	РабочееВремя.Колонки.Добавить("ДатаРегистрации");
	РабочееВремя.Колонки.Добавить("ДатаСписания");
	РабочееВремя.Колонки.Добавить("ЗадачаПроекта");
	РабочееВремя.Колонки.Добавить("ИдентификаторЗаписи");
	РабочееВремя.Колонки.Добавить("ОписаниеРаботы");
	РабочееВремя.Колонки.Добавить("Проект");
	РабочееВремя.Колонки.Добавить("Сотрудник");
	РабочееВремя.Колонки.Добавить("Часы");
	СтруктураДанных.Вставить("РабочееВремя", РабочееВремя);
	
	Возврат СтруктураДанных;
	
КонецФункции

// Функция - Сформировать регистрацию рабочего времени
//
// Параметры:
//  СтруктураДанных - Структура - Данные шапки и табличной части по которой создается документ регистрация рабочего времени
// 
// Возвращаемое значение:
//  ДокументСсылка.РегистрацияРабочегоВремени - Ссылка на созданный документ
//
Функция СформироватьРегистрациюРабочегоВремени(СтруктураДанных) Экспорт
	
	ДокументОбъект = Документы.РегистрацияРабочегоВремени.СоздатьДокумент();
	ЗаполнитьЗначенияСвойств(ДокументОбъект, СтруктураДанных, , "РабочееВремя");
	ДокументОбъект.РабочееВремя.Загрузить(СтруктураДанных.РабочееВремя);
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	Возврат ДокументОбъект.Ссылка;
	
КонецФункции

#КонецОбласти