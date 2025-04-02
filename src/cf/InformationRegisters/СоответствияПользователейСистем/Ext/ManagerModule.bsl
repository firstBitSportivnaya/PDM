﻿// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	//Ограничение.Текст = "РазрешитьЧтение";

КонецПроцедуры // ПриЗаполненииОграниченияДоступа

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти // ДляВызоваИзДругихПодсистем

// Добавить запись.
// 
// Параметры:
//  ПараметрыЗаписи - Структура - набор параметров Для записи. Ключи:
//   * НастройкаИнтеграции - СправочникСсылка.НастройкиИнтеграции - Настройка интеграции
//   * ТипИдентификации - ПеречислениеСсылка.ТипыИдентификацииСистем - Тип идентификации
//   * ЗначениеСистемы - Строка - Значение сторонней системы, интегрируемой с 1С
//   * Пользователь - СправочникСсылка.Пользователи, Неопределено - Ссылка на пользователя 1С
Процедура ДобавитьЗапись(ПараметрыЗаписи) Экспорт
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ПараметрыЗаписи);
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Изменить запись.
// 
// Параметры:
//  ПараметрыЗаписи - Структура - набор параметров Для записи. Ключи:
//   * НастройкаИнтеграции - СправочникСсылка.НастройкиИнтеграции - Настройка интеграции
//   * ТипИдентификации - ПеречислениеСсылка.ТипыИдентификацииСистем - Тип идентификации
//   * ЗначениеСистемы - Строка - Значение сторонней системы, интегрируемой с 1С
Процедура ИзменитьЗапись(ПараметрыЗаписи) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	
	Если ЗначениеЗаполнено(ПараметрыЗаписи.НастройкаИнтеграции) Тогда
		НаборЗаписей.Отбор.НастройкаИнтеграции.Установить(ПараметрыЗаписи.НастройкаИнтеграции);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыЗаписи.ТипИдентификации) Тогда
		НаборЗаписей.Отбор.ТипИдентификации.Установить(ПараметрыЗаписи.ТипИдентификации);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыЗаписи.ЗначениеСистемы) Тогда
		НаборЗаписей.Отбор.ЗначениеСистемы.Установить(ПараметрыЗаписи.ЗначениеСистемы);
	КонецЕсли;
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() Тогда
		Запись = НаборЗаписей[0];
		Для Каждого КлючИЗначение Из ПараметрыЗаписи Цикл
			Запись[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
		КонецЦикла;
		
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Удалить запись.
// 
// Параметры:
//  ПараметрыЗаписи - Структура - набор параметров Для записи. Ключи:
//   * НастройкаИнтеграции - СправочникСсылка.НастройкиИнтеграции - Настройка интеграции
//   * ТипИдентификации - ПеречислениеСсылка.ТипыИдентификацииСистем - Тип идентификации
//   * ЗначениеСистемы - Строка - Значение сторонней системы, интегрируемой с 1С
Процедура УдалитьЗаписи(ПараметрыЗаписи) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	Для Каждого КлючИЗначение Из ПараметрыЗаписи Цикл
		Если Не ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей.Отбор[КлючИЗначение.Ключ].Установить(КлючИЗначение.Значение);
	КонецЦикла;
	
	НаборЗаписей.Очистить();
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Получить таблицу соответствий пользователей систем.
// 
// Параметры:
//  МассивИдентификаторовПользователей	 - Массив - Массив идентификаторов пользователей
//  МассивИменПользователей				 - Массив - Массив имен пользователей
//  НастройкиИнтеграции					 - СправочникСсылка.НастройкиИнтеграции - Настройки интеграции
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Получить таблицу соответствий пользователей систем
Функция ПолучитьТаблицуСоответствийПользователейСистем(
	МассивИдентификаторовПользователей, МассивИменПользователей, НастройкиИнтеграции) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗначенияСистемыИд"	, МассивИдентификаторовПользователей);
	Запрос.УстановитьПараметр("ЗначенияСистемыЛогин", МассивИменПользователей);
	Запрос.УстановитьПараметр("НастройкаИнтеграции"	, НастройкиИнтеграции);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	СоответствияПользователейСистем.НастройкаИнтеграции КАК НастройкаИнтеграции,
	|	СоответствияПользователейСистем.ЗначениеСистемы КАК ЗначениеСистемы,
	|	СоответствияПользователейСистем.Пользователь КАК Пользователь,
	|	1 КАК Приоритет,
	|	СоответствияПользователейСистем.Зарегистрирован КАК Зарегистрирован
	|ПОМЕСТИТЬ ВТПользователиСистем
	|ИЗ
	|	РегистрСведений.СоответствияПользователейСистем КАК СоответствияПользователейСистем
	|ГДЕ
	|	СоответствияПользователейСистем.НастройкаИнтеграции = &НастройкаИнтеграции
	|	И СоответствияПользователейСистем.ТипИдентификации = ЗНАЧЕНИЕ(Перечисление.ТипыИдентификацииСистем.Идентификатор)
	|	И СоответствияПользователейСистем.ЗначениеСистемы В (&ЗначенияСистемыИд)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СоответствияПользователейСистем.НастройкаИнтеграции КАК НастройкаИнтеграции,
	|	СоответствияПользователейСистем.ЗначениеСистемы,
	|	СоответствияПользователейСистем.Пользователь,
	|	2,
	|	СоответствияПользователейСистем.Зарегистрирован КАК Зарегистрирован
	|ИЗ
	|	РегистрСведений.СоответствияПользователейСистем КАК СоответствияПользователейСистем
	|ГДЕ
	|	СоответствияПользователейСистем.НастройкаИнтеграции = &НастройкаИнтеграции
	|	И СоответствияПользователейСистем.ТипИдентификации = ЗНАЧЕНИЕ(Перечисление.ТипыИдентификацииСистем.ИмяПользователя)
	|	И СоответствияПользователейСистем.ЗначениеСистемы В (&ЗначенияСистемыЛогин)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТПользователиСистем.НастройкаИнтеграции КАК НастройкаИнтеграции,
	|	ВТПользователиСистем.ЗначениеСистемы КАК ЗначениеСистемы,
	|	ВТПользователиСистем.Пользователь КАК Пользователь,
	|	ВТПользователиСистем.Пользователь.ФизическоеЛицо КАК Сотрудник,
	|	ВТПользователиСистем.Приоритет КАК Приоритет,
	|	ВТПользователиСистем.Зарегистрирован КАК Зарегистрирован
	|ИЗ
	|	ВТПользователиСистем КАК ВТПользователиСистем
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	
	ВыгрузкаРезультатаЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат ВыгрузкаРезультатаЗапроса;
	
КонецФункции

Процедура ОповеститьПользователяОбОкончанииРегистрации(БотСсылка, НастройкаИнтеграции, Получатель) Экспорт
	
	ДанныеСообщения = Новый Структура;
	ДанныеСообщения.Вставить("ТипСообщения"	, Перечисления.ТипыСообщенийTelegramBot.ОтправкаСообщения);
	ТекстСообщения = ИнтеграцияСБотамиСлужебныйСервер.ПолучитьТекстСообщенияПредопределенногоОтвета(
		БотСсылка, Перечисления.ТипыПредопределенныхОтветовБота.ОкончаниеРегистрации);
	ДанныеСообщения.Вставить("Содержимое", ТекстСообщения);
	
	Результат = ИнтеграцияСБотамиСервер.ВыполнитьОтправкуСообщения(
		БотСсылка, ДанныеСообщения, Получатель);
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("НастройкаИнтеграции"	, НастройкаИнтеграции);
	ПараметрыЗаписи.Вставить("ИдентификаторЧата"	, Получатель);
	ПараметрыЗаписи.Вставить("ОповещенииОбОкончании", Результат.Идентификатор);
	
	РегистрыСведений.РегистрацияПользователейБота.ИзменитьЗапись(ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли