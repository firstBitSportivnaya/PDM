﻿// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|	ЭтотСписок КАК КадровыеИзменения
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
	|	ПО Пользователи.ФизическоеЛицо = КадровыеИзменения.Сотрудник
	|;
	|РазрешитьЧтение
	|ГДЕ
	|	ЭтоАвторизованныйПользователь(Пользователи.Ссылка) ИЛИ ЗначениеРазрешено(КадровыеИзменения.Отдел) ИЛИ ЗначениеРазрешено(КадровыеИзменения.Проект)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ЗначениеРазрешено(КадровыеИзменения.Отдел) ИЛИ ЗначениеРазрешено(КадровыеИзменения.Проект)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

// Подготовить параметры проведения.
// 
// Параметры:
//  ДокументСсылка - ДокументСсылка.КадровыеИзменения - ссылка на документ
//  Отказ          - Булево
// 
// Возвращаемое значение:
//  Структура - Подготовить параметры проведения
Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
	
	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	Результат    = Запрос.ВыполнитьПакет();
	
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	Реквизиты        = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	Для Каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс
	
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если Не ВидФормы = "ФормаДокумента" И Не ВидФормы = "ФормаОбъекта" Тогда
		Возврат;
	КонецЕсли;

	ВидОперации = Неопределено; 

	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		ВидОперации	= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Ключ, "ВидОперации");
	КонецЕсли;

	// Если документ копируется, то вид операции получаем из копируемого документа.
	Если НЕ ЗначениеЗаполнено(ВидОперации) Тогда
		Если Параметры.Свойство("ЗначениеКопирования")
			И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			ВидОперации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				Параметры.ЗначениеКопирования, "ВидОперации");
		КонецЕсли;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ВидОперации) Тогда
		Если Параметры.Свойство("ЗначенияЗаполнения") 
			И ТипЗнч(Параметры.ЗначенияЗаполнения) = Тип("Структура") Тогда
			Если Параметры.ЗначенияЗаполнения.Свойство("ВидОперации") Тогда
				ВидОперации	= Параметры.ЗначенияЗаполнения.ВидОперации;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	ФормыКадровыхИзменений = ПолучитьСоответствиеВидовОперацийФормам();
	ВыбраннаяФорма = ФормыКадровыхИзменений[ВидОперации];
	Если ВыбраннаяФорма = Неопределено Тогда
		ВыбраннаяФорма = "ФормаДокумента";
		Параметры.Вставить("ИзменитьВидОперации");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий
		
#Область СлужебныеПроцедурыИФункции

// Текст запроса реквизиты документа.
// 
// Параметры:
//  НомераТаблиц - Структура - Номера таблиц
// 
// Возвращаемое значение:
//  Строка - Текст запроса реквизиты документа
Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)

	НомераТаблиц.Вставить("ВременнаяТаблицаРеквизиты"	, НомераТаблиц.Количество());
	НомераТаблиц.Вставить("Реквизиты"					, НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КадровыеИзменения.Дата,
	|	КадровыеИзменения.Номер,
	|	КадровыеИзменения.ПометкаУдаления,
	|	КадровыеИзменения.Ссылка,
	|	КадровыеИзменения.ВидОперации,
	|	КадровыеИзменения.ВидСобытия,
	|	КадровыеИзменения.ДатаСобытия,
	|	КадровыеИзменения.Сотрудник,
	|	КадровыеИзменения.Субподряд,
	|	КадровыеИзменения.Офис,
	|	КадровыеИзменения.Отдел,
	|	КадровыеИзменения.Должность,
	|	КадровыеИзменения.Позиция,
	|	КадровыеИзменения.Проект
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.КадровыеИзменения КАК КадровыеИзменения
	|ГДЕ
	|	КадровыеИзменения.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.Дата,
	|	Реквизиты.Номер,
	|	Реквизиты.ПометкаУдаления,
	|	Реквизиты.Ссылка,
	|	Реквизиты.ВидОперации,
	|	Реквизиты.ВидСобытия,
	|	Реквизиты.ДатаСобытия,
	|	Реквизиты.Сотрудник,
	|	Реквизиты.Субподряд,
	|	Реквизиты.Офис,
	|	Реквизиты.Отдел,
	|	Реквизиты.Должность,
	|	Реквизиты.Позиция,
	|	Реквизиты.Проект
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	
	Возврат ТекстЗапроса + ОбщегоНазначения.РазделительПакетаЗапросов();
	
КонецФункции

Функция ПолучитьСоответствиеВидовОперацийФормам() Экспорт

	ФормыКадровыеИзменения = Новый Соответствие;
	ФормыКадровыеИзменения.Вставить(
		Перечисления.ВидыОперацийКадровыеИзменения.ПриемПереводУвольнение	, "ФормаДокументаПриемПереводУвольнение");
	ФормыКадровыеИзменения.Вставить(
		Перечисления.ВидыОперацийКадровыеИзменения.ПривлечениеНаПроект		, "ФормаДокументаПривлечениеНаПроект");

	Возврат ФормыКадровыеИзменения;

КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли