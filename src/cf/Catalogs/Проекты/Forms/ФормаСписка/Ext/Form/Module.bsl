﻿// @strict-types

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПодготовитьФормуНаСервере();

КонецПроцедуры // ПриСозданииНаСервере

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры // ПриОткрытии

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // СписокПриАктивизацииСтроки

// Список перед началом изменения.
// 
// Параметры:
//  Элемент - ТаблицаФормы - Элемент
//  Отказ - Булево - Отказ
&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ДанныеСтроки = Элемент.ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
    // СтандартныеПодсистемы.ОценкаПроизводительности
    ШаблонСтроки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
    	"ru = 'СозданиеФормы%1'; en = 'CreatingForm%2'",
    	"Проект", "Project");
	КлючеваяОперация = НСтр(ШаблонСтроки);
	
	ОценкаПроизводительностиКлиент.ЗамерВремени(КлючеваяОперация);
    // Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры // СписокПередНачаломИзменения

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
	
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
	
КонецПроцедуры // Подключаемый_ВыполнитьКоманду

// Подключаемый выполнить команду на сервере.
// 
// Параметры:
//  Контекст  - Структура
//  Результат - Структура
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
	
КонецПроцедуры // Подключаемый_ВыполнитьКомандуНаСервере

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры // Подключаемый_ОбновитьКоманды

#КонецОбласти // СтандартныеПодсистемы

&НаСервере
Процедура ПодготовитьФормуНаСервере()



КонецПроцедуры // ПодготовитьФормуНаСервере

#КонецОбласти // СлужебныеПроцедурыИФункции