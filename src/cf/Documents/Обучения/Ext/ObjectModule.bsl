﻿// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры
	
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
//	Запрос = Новый Запрос;
//	Запрос.Текст = "ВЫБРАТЬ
//	|	ОбученияУчастники.Сотрудник,
//	|	ОбученияУчастники.Ссылка
//	|ИЗ
//	|	Справочник.Обучения.Участники КАК ОбученияУчастники
//	|ГДЕ
//	|	НЕ ОбученияУчастники.Ссылка = &Источник
//	|	И ОбученияУчастники.Ссылка.ДатаОбучения = &ДатаОбучения";
//	
//	Запрос.УстановитьПараметр("Источник"	, Ссылка);
//	Запрос.УстановитьПараметр("ДатаОбучения", Дата);
//	
//	ВыгрузкаРезультатовЗапроса = Запрос.Выполнить().Выгрузить();
//	
//	Ошибки = Неопределено;
//	Для Каждого УчастникОбучения Из Участники Цикл
//		
//		ПоискСотрудника = ВыгрузкаРезультатовЗапроса.Найти(УчастникОбучения.Сотрудник, "Сотрудник");
//		Если ПоискСотрудника <> Неопределено Тогда
//			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
//				"ru = 'Сотрудник %1 уже участвует в обучении ""%2"", назначенное на это время'",
//				УчастникОбучения.Сотрудник, ПоискСотрудника.Ссылка);
//			
//			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , НСтр(ТекстСообщения));
//		КонецЕсли;
//		
//	КонецЦикла;
//	 
//	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПараметрыПроведения = Документы.Обучения.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПараметрыПроведения.Свойство("Реквизиты") Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыДокумента	= ПараметрыПроведения.Реквизиты;
	УчастникиТаблица	= ПараметрыПроведения.ВременнаяТаблицаУчастники;
	КомпетенцииТаблица	= ПараметрыПроведения.ВременнаяТаблицаКомпетенции;
	
	Если Статус = Перечисления.СтатусыОбучений.Выполнено Тогда
		КомпетенцииМассив = ОбщегоНазначенияКлиентСервер.СвернутьМассив(КомпетенцииТаблица.ВыгрузитьКолонку("Компетенция"));
		ГрадацииВремени = ОценкаСотрудниковСервер.ПолучитьГрадацииВремениПоКомпетенциям(КомпетенцииМассив);
		
		Если РеквизитыДокумента.ОбщееКоличествоЧасов <> 0 Тогда
			КоличествоКомпетенций = КомпетенцииМассив.Количество();	
			КоличествоВремениНаКомпетенцию = КоличествоЧасов / КоличествоКомпетенций;
		КонецЕсли;
		
		Движения.УчетВремениПоКомпетенциям.Очистить();
		
		Для Каждого УчастникСтрока Из УчастникиТаблица Цикл
			
			УчастникОбучения = УчастникСтрока.Сотрудник;
			
			Для Каждого КомпетенцияСтрока Из КомпетенцииТаблица Цикл
				
				КомпетенцияОбучения = КомпетенцияСтрока.Компетенция;
				
				НоваяЗапись = Движения.УчетВремениПоКомпетенциям.Добавить();
				НоваяЗапись.Период		= РеквизитыДокумента.Дата;
				НоваяЗапись.Регистратор	= РеквизитыДокумента.Ссылка;
				НоваяЗапись.Сотрудник	= УчастникОбучения;
				НоваяЗапись.Компетенция	= КомпетенцияОбучения;
				
				Если РеквизитыДокумента.ОбщееКоличествоЧасов <> 0 Тогда
					КоличествоЧасов = КоличествоВремениНаКомпетенцию;
				Иначе
					КоличествоЧасов = КомпетенцияСтрока.КоличествоЧасов;
				КонецЕсли;
				
				НоваяЗапись.Часов	= КоличествоЧасов;
				
			КонецЦикла;
			
		КонецЦикла;
		
		Движения.УчетВремениПоКомпетенциям.Записывать = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'; en = 'Invalid object call on client.'");
#КонецЕсли