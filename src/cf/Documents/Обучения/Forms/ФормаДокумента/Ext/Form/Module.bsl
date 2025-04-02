﻿// @strict-types
#Область ОписаниеПеременных

// СтандартныеПодсистемы.ОценкаПроизводительности
&НаКлиенте
Перем ИдентификаторЗамераПроведение;
// Конец СтандартныеПодсистемы.ОценкаПроизводительности

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	УстановитьВидимостьЭлементовФормы();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ИдентификаторЗамераПроведение = ОценкаПроизводительностиКлиент.ЗамерВремени();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ОценкаПроизводительностиКлиент.УстановитьКлючевуюОперациюЗамера(ИдентификаторЗамераПроведение,
			"ОбученияПроведение");
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности

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
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ОбщееКоличествоЧасовПриИзменении(Элемент)
	
	ОбщееКоличествоЧасовПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбщееКоличествоЧасовПриИзмененииНаСервере()
	
	Если Объект.ОбщееКоличествоЧасов Тогда
		Для Каждого СтрокаКомпетенции Из Объект.Компетенции Цикл
			СтрокаКомпетенции.КоличествоЧасов = 0;
		КонецЦикла;
	Иначе
		Объект.КоличествоЧасов = 0;
	КонецЕсли;
	
	УстановитьВидимостьКоличестваЧасов();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область СлужебныеПроцедурыИФункции

//@skip-check module-unused-method
#Область СтандартныеПодсистемы

// Подключаемый выполнить команду.
// 
// Параметры:
//  Команда - КомандаФормы
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)

	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);

КонецПроцедуры

// Подключаемый выполнить команду на сервере.
// 
// Параметры:
//  Контекст  - Структура
//  Результат - Структура
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт

	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()

	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);

КонецПроцедуры

#КонецОбласти // СтандартныеПодсистемы

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы()
	
	 УстановитьВидимостьКоличестваЧасов();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКоличестваЧасов()
	
	Если Объект.ОбщееКоличествоЧасов Тогда
		Элементы.КоличествоЧасов.Видимость				= Истина;
		Элементы.КомпетенцииКоличествоЧасов.Видимость	= Ложь;
	Иначе
		Элементы.КоличествоЧасов.Видимость				= Ложь;
		Элементы.КомпетенцииКоличествоЧасов.Видимость	= Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
