﻿// @strict-types

#Область ПрограммныйИнтерфейс

#Область СобытияИсточников

// Добавляет или обновляет данные в регистре сведений "Компетенции сотрудников".
// 
// Параметры:
//  Источник			 - СправочникСсылка.Обучения - Справочник, регистрирующий часы
//  Участники			 - ТабличнаяЧасть	 - Участники обучения
//  Компетенции			 - ТабличнаяЧасть	 - Компетенции, которые развивает обучение
//  КоличествоЧасовОбщее - Число			 - Количество часов, потраченных на обучение
Процедура ОбновитьКомпетенцииСотрудниковПослеОбучения(Источник, Участники, Компетенции, КоличествоЧасовОбщее) Экспорт
	
//	КомпетенцииМассив = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Компетенции.ВыгрузитьКолонку("Компетенция"));
//	ГрадацииВремени = ПолучитьГрадацииВремениПоКомпетенциям(КомпетенцииМассив);
//	
//	Если КоличествоЧасовОбщее <> 0 Тогда
//		КоличествоКомпетенций = КомпетенцииМассив.Количество();	
//		КоличествоВремениНаКомпетенцию = КоличествоЧасовОбщее / КоличествоКомпетенций;
//	КонецЕсли;
//	
//	СотрудникиМассив = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Участники.ВыгрузитьКолонку("Сотрудник"));
//	КомпетенцииСотрудниковИтогиЧасов = ПолучитьИтоговоеКоличествоЧасовПоКомпетенциям(
//		СотрудникиМассив, КомпетенцииМассив, Источник);
//	
//	НаборЗаписей = РегистрыСведений.КомпетенцииСотрудников.СоздатьНаборЗаписей();
//	НаборЗаписей.Отбор.Источник.Установить(Источник);
//	НаборЗаписей.Прочитать();
//	НаборЗаписей.Очистить();
//	
//	Для Каждого УчастникСтрока Из Участники Цикл
//		
//		УчастникОбучения = УчастникСтрока.Сотрудник;
//		
//		Для Каждого КомпетенцияСтрока Из Компетенции Цикл
//			
//			КомпетенцияОбучения = КомпетенцияСтрока.Компетенция;
//			
//			НоваяЗапись = НаборЗаписей.Добавить();
//			НоваяЗапись.Период		= Источник.ДатаОбучения;
//			НоваяЗапись.Сотрудник	= УчастникОбучения;
//			НоваяЗапись.Компетенция	= КомпетенцияОбучения;
//			НоваяЗапись.Источник	= Источник;
//			
//			Если КоличествоЧасовОбщее <> 0 Тогда
//				КоличествоЧасов = КоличествоВремениНаКомпетенцию;
//			Иначе
//				КоличествоЧасов = КомпетенцияСтрока.КоличествоЧасов;
//			КонецЕсли;
//			
//			НоваяЗапись.Часов	= КоличествоЧасов;
//			
//			СтруктураОтбора = Новый Структура;
//			СтруктураОтбора.Вставить("Сотрудник"	, УчастникОбучения);
//			СтруктураОтбора.Вставить("Компетенция"	, КомпетенцияОбучения);
//			НайденныеСтроки = КомпетенцииСотрудниковИтогиЧасов.НайтиСтроки(СтруктураОтбора);
//			Если НайденныеСтроки.Количество() Тогда
//				КоличествоЧасов = КоличествоЧасов + НайденныеСтроки[0].НарастающийИтог;
//			КонецЕсли;
//			
//			НоваяЗапись.НарастающийИтог = КоличествоЧасов;
//			
//		КонецЦикла;
//		
//	КонецЦикла;
//	
//	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ОбновитьКомпетенцииСотрудниковПоУчетуВремени(Источник) Экспорт
	
//	СотрудникиМассив	= ОбщегоНазначенияКлиентСервер.СвернутьМассив(Источник.ВыгрузитьКолонку("Сотрудник"));
//	
//	ЗадачиМассив = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Источник.ВыгрузитьКолонку("ЗадачаПроекта"));
//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = "ВЫБРАТЬ
//	|	ЗадачиМетки.Компетенция
//	|ИЗ
//	|	Справочник.ЗадачиПроектов.Метки КАК ЗадачиМетки
//	|ГДЕ
//	|	ЗадачиМетки.Ссылка В (&Задачи)";
//	
//	Запрос.УстановитьПараметр("Задачи", ЗадачиМассив);
//	
//	ВыгрузкаРезультатаЗапроса = Запрос.Выполнить().Выгрузить();
//	КомпетенцииМассив = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Источник.ВыгрузитьКолонку("Компетенция"));
//	
//	ГрадацииВремени = ПолучитьГрадацииВремениПоКомпетенциям(КомпетенцииМассив);
//
//	КомпетенцииСотрудниковИтогиЧасов = ПолучитьИтоговоеКоличествоЧасовПоКомпетенциям(
//		СотрудникиМассив, КомпетенцииМассив, Источник);
//	
//	НаборЗаписей = РегистрыСведений.КомпетенцииСотрудников.СоздатьНаборЗаписей();
//	НаборЗаписей.Отбор.Источник.Установить(Источник);
//	НаборЗаписей.Прочитать();
//	НаборЗаписей.Очистить();
//	
//	Для Каждого УчастникСтрока Из Участники Цикл
//		
//		УчастникОбучения = УчастникСтрока.Сотрудник;
//		
//		Для Каждого КомпетенцияСтрока Из Компетенции Цикл
//			
//			КомпетенцияОбучения = КомпетенцияСтрока.Компетенция;
//			
//			НоваяЗапись = НаборЗаписей.Добавить();
//			НоваяЗапись.Период		= Источник.ДатаОбучения;
//			НоваяЗапись.Сотрудник	= УчастникОбучения;
//			НоваяЗапись.Компетенция	= КомпетенцияОбучения;
//			НоваяЗапись.Источник	= Источник;
//			
//			Если КоличествоЧасовОбщее <> 0 Тогда
//				КоличествоЧасов = КоличествоВремениНаКомпетенцию;
//			Иначе
//				КоличествоЧасов = КомпетенцияСтрока.КоличествоЧасов;
//			КонецЕсли;
//			
//			НоваяЗапись.Часов	= КоличествоЧасов;
//			
//			СтруктураОтбора = Новый Структура;
//			СтруктураОтбора.Вставить("Сотрудник"	, УчастникОбучения);
//			СтруктураОтбора.Вставить("Компетенция"	, КомпетенцияОбучения);
//			НайденныеСтроки = КомпетенцииСотрудниковИтогиЧасов.НайтиСтроки(СтруктураОтбора);
//			Если НайденныеСтроки.Количество() Тогда
//				КоличествоЧасов = КоличествоЧасов + НайденныеСтроки[0].НарастающийИтог;
//			КонецЕсли;
//			
//			НоваяЗапись.НарастающийИтог = КоличествоЧасов;
//			
//			УровеньКомпетенции = ПолучитьУровеньКомпетенцииПоГрадации(ГрадацииВремени, КомпетенцияОбучения, КоличествоЧасов);
//			
//			НоваяЗапись.УровеньЗнания	= УровеньКомпетенции;
//			
//		КонецЦикла;
//		
//	КонецЦикла;
//	
//	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти // СобытияИсточников

Процедура ОчиститьКомпетенцииСотрудниковПоИсточнику(Источник) Экспорт
	
//	НаборЗаписей = РегистрыСведений.КомпетенцииСотрудников.СоздатьНаборЗаписей();
//	НаборЗаписей.Отбор.Источник.Установить(Источник);
//	НаборЗаписей.Очистить();
//	НаборЗаписей.Записать();
	
КонецПроцедуры

#Область ПересчетИтогов

Процедура ПересчитатьИтогиПриУдалении(Источник, КомпетенцииМассив, СотрудникиМассив, Период) Экспорт
	
//	ГрадацииВремени = ПолучитьГрадацииВремениПоКомпетенциям(КомпетенцииМассив);
//	
//	Запрос = Новый Запрос;
//	Запрос.УстановитьПараметр("Период"			, Период);
//	Запрос.УстановитьПараметр("Сотрудники"		, СотрудникиМассив);
//	Запрос.УстановитьПараметр("Компетенции"		, КомпетенцииМассив);
//	Запрос.УстановитьПараметр("Источник"		, Источник);
//	Запрос.Текст = "ВЫБРАТЬ
//	|	КомпетенцииСотрудниковСрезПоследних.Сотрудник,
//	|	КомпетенцииСотрудниковСрезПоследних.Компетенция,
//	|	СУММА(КомпетенцииСотрудниковСрезПоследних.Часов) КАК Часов
//	|ИЗ
//	|	РегистрСведений.КомпетенцииСотрудников.СрезПоследних(&Период, Сотрудник В (&Сотрудники)
//	|	И Компетенция В (&Компетенции)
//	|	И Источник = &Источник) КАК КомпетенцииСотрудниковСрезПоследних
//	|СГРУППИРОВАТЬ ПО
//	|	КомпетенцииСотрудниковСрезПоследних.Сотрудник,
//	|	КомпетенцииСотрудниковСрезПоследних.Компетенция
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	КомпетенцииСотрудников.Период КАК Период,
//	|	КомпетенцииСотрудников.Сотрудник,
//	|	КомпетенцииСотрудников.Компетенция,
//	|	КомпетенцииСотрудников.Источник,
//	|	КомпетенцииСотрудников.НарастающийИтог
//	|ИЗ
//	|	РегистрСведений.КомпетенцииСотрудников КАК КомпетенцииСотрудников
//	|ГДЕ
//	|	КомпетенцииСотрудников.Период > &Период
//	|	И КомпетенцииСотрудников.Сотрудник В (&Сотрудники)
//	|	И КомпетенцииСотрудников.Компетенция В (&Компетенции)
//	|
//	|УПОРЯДОЧИТЬ ПО
//	|	Период";
//	
//	РезультатПакетов = Запрос.ВыполнитьПакет();
//	ВыгрузкаПоДокументу = РезультатПакетов[0].Выгрузить();
//	
//	ВыборкаРезультатаЗапроса = РезультатПакетов[1].Выбрать();
//	
//	Пока ВыборкаРезультатаЗапроса.Следующий() Цикл
//		
//		СтруктураОтбора = Новый Структура;
//		СтруктураОтбора.Вставить("Сотрудник"	, ВыборкаРезультатаЗапроса.Сотрудник);
//		СтруктураОтбора.Вставить("Компетенция"	, ВыборкаРезультатаЗапроса.Компетенция);
//		НайденныеСтроки = ВыгрузкаПоДокументу.НайтиСтроки(СтруктураОтбора);
//		Если НайденныеСтроки.Количество() Тогда
//			ВычестьЧасов = НайденныеСтроки[0].Часов;
//		
//			МенеджерЗаписи = РегистрыСведений.КомпетенцииСотрудников.СоздатьМенеджерЗаписи();
//			МенеджерЗаписи.Период		= ВыборкаРезультатаЗапроса.Период;
//			МенеджерЗаписи.Сотрудник	= ВыборкаРезультатаЗапроса.Сотрудник;
//			МенеджерЗаписи.Компетенция	= ВыборкаРезультатаЗапроса.Компетенция;
//			МенеджерЗаписи.Источник		= ВыборкаРезультатаЗапроса.Источник;
//			
//			МенеджерЗаписи.Прочитать();
//			
//			Если МенеджерЗаписи.Выбран() Тогда
//				МенеджерЗаписи.НарастающийИтог			= МенеджерЗаписи.НарастающийИтог - ВычестьЧасов;
//				
//				МенеджерЗаписи.Записать();
//			КонецЕсли;
//			
//		КонецЕсли;
//		
//	КонецЦикла;
	
КонецПроцедуры 

Процедура ПересчитатьНарастающиеИтоги(СотрудникиМассив = Неопределено, КомпетенцииМассив = Неопределено) Экспорт
	
//	Запрос = Новый Запрос;
//	
//	ТекстЗапроса = "ВЫБРАТЬ
//	|	КомпетенцииСотрудников.Сотрудник КАК Сотрудник,
//	|	КомпетенцииСотрудников.Компетенция,
//	|	КомпетенцииСотрудников.Источник,
//	|	КомпетенцииСотрудников.Часов
//	|ИЗ
//	|	РегистрСведений.КомпетенцииСотрудников КАК КомпетенцииСотрудников
//	|ГДЕ
//	|	&УсловияОтбора";
//	
//	УсловиеСтрокой = "";
//	
//	Если ЗначениеЗаполнено(СотрудникиМассив) Тогда
//		УсловиеСтрокой = УсловиеСтрокой + "КомпетенцииСотрудников.Сотрудник В (&Сотрудники)";
//		Запрос.УстановитьПараметр("Сотрудники"	, СотрудникиМассив);
//	КонецЕсли;
//	
//	Если ЗначениеЗаполнено(КомпетенцииМассив) Тогда
//		УсловиеСтрокой = УсловиеСтрокой +  ?(ПустаяСтрока(УсловиеСтрокой), "", "
//		|	И ") + "КомпетенцииСотрудников.Компетенция В (&Компетенции)";
//		Запрос.УстановитьПараметр("Компетенции"	, КомпетенцииМассив);
//	КонецЕсли;
//	
//	Запрос.Текст = СтрЗаменить(ТекстЗапроса, "&УсловияОтбора", УсловиеСтрокой);
//	
//	РезультатЗапроса = Запрос.Выполнить();
//	ВыгрузкаРезультатаЗапроса = РезультатЗапроса.Выгрузить();
//	
//	ТаблицаСотрудникКомпетенция = ВыгрузкаРезультатаЗапроса.Скопировать();
//	ТаблицаСотрудникКомпетенция.Свернуть("Сотрудник, Компетенция");
//	
//	Если КомпетенцииМассив = Неопределено Тогда
//		КомпетенцииДоСвертки = ТаблицаСотрудникКомпетенция.ВыгрузитьКолонку("Компетенция");
//		КомпетенцииМассив = ОбщегоНазначенияКлиентСервер.СвернутьМассив(КомпетенцииДоСвертки);
//	КонецЕсли;
//	
//	ГрадацииВремени = ПолучитьГрадацииВремениПоКомпетенциям(КомпетенцииМассив);
//	
//	Для Каждого СотрудникКомпетенция Из ТаблицаСотрудникКомпетенция Цикл
//		
//		НаборЗаписей = РегистрыСведений.КомпетенцииСотрудников.СоздатьНаборЗаписей();
//		НаборЗаписей.Отбор.Сотрудник.Установить(СотрудникКомпетенция.Сотрудник);
//		НаборЗаписей.Отбор.Компетенция.Установить(СотрудникКомпетенция.Компетенция);
//		НаборЗаписей.Прочитать();
//		
//		НарастающийИтог = 0;
//		Для Каждого Запись Из НаборЗаписей Цикл
//			
//			СтруктураОтбора = Новый Структура;
//			СтруктураОтбора.Вставить("Сотрудник"	, Запись.Сотрудник);
//			СтруктураОтбора.Вставить("Компетенция"	, Запись.Компетенция);
//			СтруктураОтбора.Вставить("Источник"		, Запись.Источник);
//			НайденныеСтроки = ВыгрузкаРезультатаЗапроса.НайтиСтроки(СтруктураОтбора);
//			
//			Если НайденныеСтроки.Количество() Тогда
//				
//				Запись.Часов = НайденныеСтроки[0].Часов;
//				НарастающийИтог = НарастающийИтог + НайденныеСтроки[0].Часов;
//				Запись.НарастающийИтог = НарастающийИтог;
//				
//			КонецЕсли;
//			
//		КонецЦикла;
//		
//		НаборЗаписей.Записать();
//		
//	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти // ПересчетИтогов

Функция ПолучитьУровеньКомпетенцииПоГрадации(ГрадацииВремени, Компетенция, КоличествоЧасов) Экспорт
	
	УровеньКомпетенции = Перечисления.УровниЗнания.НеИзучено;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Компетенция", Компетенция);
	НайденныеСтроки = ГрадацииВремени.НайтиСтроки(СтруктураОтбора);
	
	Для Каждого СтрокаГрадации Из НайденныеСтроки Цикл
		Если СтрокаГрадации.ЧасовОт <= КоличествоЧасов
			И (Не ЗначениеЗаполнено(СтрокаГрадации.ЧасовДо) Или КоличествоЧасов <= СтрокаГрадации.ЧасовДо) Тогда
			УровеньКомпетенции = СтрокаГрадации.УровеньЗнания;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат УровеньКомпетенции;
	
КонецФункции

// Возвращает таблицу градаций времени по компетенциям.
// Содержить данные об интервалах часов, необходимых для того или иного уровня знаний по компетенции. 
// 
// Параметры:
//  Компетенции	 - Массив			 - Компетенции
// 
// Возвращаемое значение:
//  Градации	 - ТаблицаЗначений	 - Таблица содержит информацию о том, сколько нужно часов для   
Функция ПолучитьГрадацииВремениПоКомпетенциям(Компетенции = Неопределено, ТипКомпетенции = Неопределено) Экспорт
	
	Градации = Новый ТаблицаЗначений;
	Градации.Колонки.Добавить("Компетенция"		, Новый ОписаниеТипов("СправочникСсылка.Компетенции"));
	Градации.Колонки.Добавить("УровеньЗнания"	, Новый ОписаниеТипов("ПеречислениеСсылка.УровниЗнания"));
	Градации.Колонки.Добавить("ЧасовОт"			, ОбщегоНазначения.ОписаниеТипаЧисло(7, 2));
	Градации.Колонки.Добавить("ЧасовДо"			, ОбщегоНазначения.ОписаниеТипаЧисло(7, 2));
	
	ПорядокУровней = Новый ТаблицаЗначений;
	ПорядокУровней.Колонки.Добавить("УровеньЗнания"	, Новый ОписаниеТипов("ПеречислениеСсылка.УровниЗнания"));
	ПорядокУровней.Колонки.Добавить("Порядок"		, ОбщегоНазначения.ОписаниеТипаЧисло(5, 0));
	
	ЗначенияУровней = Метаданные.Перечисления.УровниЗнания.ЗначенияПеречисления;
	Инкремент = 1;
	Для Каждого ЗначениеПеречисления Из ЗначенияУровней Цикл
		НовыйЭлемент = ПорядокУровней.Добавить();
		НовыйЭлемент.УровеньЗнания	= Перечисления.УровниЗнания[ЗначениеПеречисления.Имя];
		НовыйЭлемент.Порядок		= Инкремент;
		
		Инкремент = Инкремент + 1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТЗПорядокУровней", ПорядокУровней);
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	ТЗПорядокУровней.УровеньЗнания КАК УровеньЗнания,
	|	ТЗПорядокУровней.Порядок КАК Порядок
	|ПОМЕСТИТЬ ВТПорядокУровней
	|ИЗ
	|	&ТЗПорядокУровней КАК ТЗПорядокУровней"
	+ ОбщегоНазначения.РазделительПакетаЗапросов();
	
	Если ЗначениеЗаполнено(Компетенции) Тогда
		ТекстЗапроса = ТекстЗапроса + "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ГрадацииВремениПоКомпетенциям.Компетенция,
		|	ГрадацииВремениПоКомпетенциям.УровеньЗнания,
		|	ГрадацииВремениПоКомпетенциям.НеобходимоЧасов
		|ИЗ
		|	РегистрСведений.ГрадацииВремениПоКомпетенциям КАК ГрадацииВремениПоКомпетенциям
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПорядокУровней КАК ВТПорядокУровней
		|		ПО ГрадацииВремениПоКомпетенциям.УровеньЗнания = ВТПорядокУровней.УровеньЗнания
		|ГДЕ
		|	ГрадацииВремениПоКомпетенциям.Компетенция В (&Компетенции)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ГрадацииВремениПоКомпетенциям.Компетенция.Наименование,
		|	ВТПорядокУровней.Порядок";
		
		Запрос.УстановитьПараметр("Компетенции", Компетенции);
	Иначе
		ТекстЗапроса = ТекстЗапроса + "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Компетенции.Ссылка КАК Компетенция
		|ПОМЕСТИТЬ ВТКомпетенции
		|ИЗ
		|	Справочник.Компетенции КАК Компетенции
		|ГДЕ
		|	&ОтборПоТипу
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ГрадацииВремениПоКомпетенциям.Компетенция,
		|	ГрадацииВремениПоКомпетенциям.УровеньЗнания,
		|	ГрадацииВремениПоКомпетенциям.НеобходимоЧасов
		|ИЗ
		|	РегистрСведений.ГрадацииВремениПоКомпетенциям КАК ГрадацииВремениПоКомпетенциям
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПорядокУровней КАК ВТПорядокУровней
		|		ПО ГрадацииВремениПоКомпетенциям.УровеньЗнания = ВТПорядокУровней.УровеньЗнания
		|ГДЕ
		|	ГрадацииВремениПоКомпетенциям.Компетенция В
		|		(ВЫБРАТЬ
		|			Компетенция
		|		ИЗ
		|			ВТКомпетенции)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ГрадацииВремениПоКомпетенциям.Компетенция.Наименование,
		|	ВТПорядокУровней.Порядок";
		
		Если ЗначениеЗаполнено(ТипКомпетенции) Тогда
			ТекстЗапроса= СтрЗаменить(ТекстЗапроса, "&ОтборПоТипу", "Компетенции.ТипКомпетенции = &ТипКомпетенции");
			Запрос.УстановитьПараметр("ТипКомпетенции", ТипКомпетенции);
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "
			|ГДЕ
			|	&ОтборПоТипу", "");
		КонецЕсли;
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	ВыгрузкаРезультатаЗапроса = Запрос.Выполнить().Выгрузить();
	
	ПрошлаяСтрока = Неопределено;
	Для Каждого СтрокаРезультата Из ВыгрузкаРезультатаЗапроса Цикл
		
		Если ПрошлаяСтрока = Неопределено Тогда
			НоваяГрадация = Градации.Добавить();
			НоваяГрадация.Компетенция	= СтрокаРезультата.Компетенция;
			НоваяГрадация.УровеньЗнания	= СтрокаРезультата.УровеньЗнания;
			НоваяГрадация.ЧасовОт		= СтрокаРезультата.НеобходимоЧасов;
			
		ИначеЕсли СтрокаРезультата.Компетенция = ПрошлаяСтрока.Компетенция
			И СтрокаРезультата.УровеньЗнания <> ПрошлаяСтрока.УровеньЗнания Тогда
			НоваяГрадация.ЧасовДо		= СтрокаРезультата.НеобходимоЧасов - 0.01;
			
			НоваяГрадация = Градации.Добавить();
			НоваяГрадация.Компетенция	= СтрокаРезультата.Компетенция;
			НоваяГрадация.УровеньЗнания	= СтрокаРезультата.УровеньЗнания;
			НоваяГрадация.ЧасовОт		= СтрокаРезультата.НеобходимоЧасов;
		
		ИначеЕсли СтрокаРезультата.Компетенция <> ПрошлаяСтрока.Компетенция Тогда
			НоваяГрадация = Градации.Добавить();
			НоваяГрадация.Компетенция	= СтрокаРезультата.Компетенция;
			НоваяГрадация.УровеньЗнания	= СтрокаРезультата.УровеньЗнания;
			НоваяГрадация.ЧасовОт		= СтрокаРезультата.НеобходимоЧасов;
			
		КонецЕсли;
		
		ПрошлаяСтрока = СтрокаРезультата;
		
	КонецЦикла;
	
	Возврат Градации;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс