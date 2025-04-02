﻿// @strict-types

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.СписокВидовОпераций.ТекущиеДанные;
	
	Если Не СтрокаТаблицы = Неопределено Тогда
		
		ОткрытьДокументВида(СтрокаТаблицы.Значение);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если Параметры.Свойство("ЗначениеКопирования") Тогда
		ЗначениеКопирования	= Параметры.ЗначениеКопирования;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
		ЗначенияЗаполнения	= Параметры.ЗначенияЗаполнения;
	КонецЕсли;
	
	Если Параметры.Свойство("Основание") Тогда
		Основание			= Параметры.Основание;
	КонецЕсли;
	
	Если Параметры.Свойство("Ключ") Тогда
		Ключ				= Параметры.Ключ;
	КонецЕсли;
	
	Если Параметры.Свойство("ИзменитьВидОперации") Тогда
		ИзменитьВидОперации	= Истина;
	КонецЕсли;
	
	ФормыДокумента   = Новый ФиксированноеСоответствие(
		Документы.КадровыеИзменения.ПолучитьСоответствиеВидовОперацийФормам());
		
	ВидыОпераций = ПолучитьСписокВидовОпераций();
	Для Каждого ВидОперации Из ВидыОпераций Цикл
		НоваяОперация = СписокВидовОпераций.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяОперация, ВидОперации);
	КонецЦикла;
	
	Если Параметры.Свойство("ВидОперации") Тогда
		ВидОперацииПриОткрытии = Параметры.ВидОперации;
		ВыделенныйЭлементСписка = СписокВидовОпераций.НайтиПоЗначению(ВидОперацииПриОткрытии);
		Если ВыделенныйЭлементСписка <> Неопределено Тогда
			Элементы.СписокВидовОпераций.ТекущаяСтрока = ВыделенныйЭлементСписка.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокВидовОпераций()
	
	СписокВидовОпераций = Новый СписокЗначений;
	
	ВсеВидыОпераций = Перечисления.ВидыОперацийКадровыеИзменения;
	
	СписокВидовОпераций.Добавить(ВсеВидыОпераций.ПриемПереводУвольнение,
		НСтр("ru = 'Прием, перевод, увольнение'; en = 'Recruitment, transfer, dismissal'"));
	СписокВидовОпераций.Добавить(ВсеВидыОпераций.ПривлечениеНаПроект,
		НСтр("ru = 'Привлечение на проект'; en = 'Attraction to project'"));
	
	Возврат СписокВидовОпераций;
	
КонецФункции

&НаКлиенте
Процедура СписокВидовОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокВидовОпераций.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОткрытьДокументВида(СтрокаТаблицы.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументВида(ВыбранныйВидОперации)
	
	Если ТипЗнч(ЗначенияЗаполнения) <> Тип("Структура") Тогда
		ЗначенияЗаполнения = Новый Структура;
	КонецЕсли;
	
	ЗначенияЗаполнения.Вставить("ВидОперации"				, ВыбранныйВидОперации);
	Если ЗначениеЗаполнено(Основание) Тогда
		ЗначенияЗаполнения.Вставить("Основание"				, Основание);
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ"						, Ключ);
	СтруктураПараметров.Вставить("ЗначенияЗаполнения"		, ЗначенияЗаполнения);
	Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		СтруктураПараметров.Вставить("ЗначениеКопирования"	, ЗначениеКопирования);
	КонецЕсли;
	Если ИзменитьВидОперации И ВыбранныйВидОперации <> ВидОперацииПриОткрытии Тогда
		СтруктураПараметров.Вставить("ИзменитьВидОперации"	, ИзменитьВидОперации);
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть();
	
	Если ВыбранныйВидОперации = ПредопределенноеЗначение(
		"Перечисление.ВидыОперацийКадровыеИзменения.ПриемПереводУвольнение") Тогда
		КлючеваяОперация = "СозданиеФормыКадровыеИзмененияПриемПереводУвольнение";
	Иначе
		КлючеваяОперация = "СозданиеФормыКадровыеИзмененияПривлечениеНаПроект";
	КонецЕсли;
	
	ОценкаПроизводительностиКлиент.ЗамерВремени(КлючеваяОперация);
	
	ОткрытьФорму("Документ.КадровыеИзменения.Форма." + ФормыДокумента[ВыбранныйВидОперации],
		 СтруктураПараметров, ВладелецФормы);
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции 