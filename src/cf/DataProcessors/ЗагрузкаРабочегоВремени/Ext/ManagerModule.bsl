﻿// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет таблицу данных из Excel фоново.
//
// Параметры:
//  Параметры	 - Структура - Структура параметров для заполнения таблицы данных.
// 
// Возвращаемое значение:
//  Структура - Результат выполнения заполнения таблицы данных.
//
Функция ПодготовитьДанныеExcelВФоне(Параметры) Экспорт
	
	Возврат ПодготовитьДанныеExcel(Параметры.СтруктураПараметров, Параметры.СообщатьОПрогрессе);
	
КонецФункции

// Загружает таблицу данных из Excel фоново.
//
// Параметры:
//  Параметры	 - Структура - Структура параметров для загрузки таблицы данных.
// 
// Возвращаемое значение:
//  Структура - Результат выполнения загрузки данных.
//
Функция ЗагрузитьДанныеExcelВФоне(Параметры) Экспорт
	
	Возврат ЗагрузитьДанныеExcel(Параметры.СтруктураПараметров, Параметры.СообщатьОПрогрессе);
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОповеститьОПрогрессе(Параметры)
	
	Параметры.ОбработаноСтрок = Параметры.ОбработаноСтрок + 1;
	ТекущийПрогресс = Цел(Параметры.ОбработаноСтрок / ?(Параметры.ВсегоСтрок, Параметры.ВсегоСтрок, 1) * 100);
	Если ТекущийПрогресс <> Параметры.ПрогрессОКоторомСообщили Тогда
		Параметры.ПрогрессОКоторомСообщили = ТекущийПрогресс;
		ДлительныеОперации.СообщитьПрогресс(ТекущийПрогресс, СтрШаблон(НСтр("ru = 'Обработано: %1 из %2'"), 
			Параметры.ОбработаноСтрок, Параметры.ВсегоСтрок));
	КонецЕсли;
	
КонецПроцедуры

Процедура СообщитьОПодготовкеДанных(ТекстСообщения)
	
	ДлительныеОперации.СообщитьПрогресс(0, ТекстСообщения);
	
КонецПроцедуры

Функция ПараметрыСообщенияОПрогрессе(Таблица)
	
	Параметры = Новый Структура;
	Параметры.Вставить("ВсегоСтрок", Таблица.Количество());
	Параметры.Вставить("ОбработаноСтрок", 0);
	Параметры.Вставить("ПрогрессОКоторомСообщили", -1);
	
	Возврат Параметры;
	
КонецФункции

Процедура ЗаписатьСобытияВЖурналРегистрации(Комментарий)
	
	СтруктураСобытий = Новый Структура("ИмяСобытия, ПредставлениеУровня, Комментарий, ДатаСобытия");
	СтруктураСобытий.ИмяСобытия = "Загрузка рабочего времени сотрудника";
	СтруктураСобытий.ПредставлениеУровня = "Ошибка";
	СтруктураСобытий.Комментарий = Комментарий; 
	СтруктураСобытий.ДатаСобытия = ТекущаяДатаСеанса();
	
	СобытияДляЖурналаРегистрации = Новый СписокЗначений();
	СобытияДляЖурналаРегистрации.Добавить(СтруктураСобытий);
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СобытияДляЖурналаРегистрации);
	
КонецПроцедуры

#Область ПрочитатьДанныхExcel

Функция ПодготовитьДанныеExcel(Параметры, СообщатьОПрогрессе)
	
	Если СообщатьОПрогрессе Тогда
		СообщитьОПодготовкеДанных(НСтр("ru = 'Чтение данных Excel'"));
	КонецЕсли;
	
	ДанныеФайла = Параметры.ДанныеФайла;
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Параметры.РасширениеФайла);
	ДанныеФайла.Записать(ИмяВременногоФайла);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Прочитать(ИмяВременногоФайла, СпособЧтенияЗначенийТабличногоДокумента.Текст);
	ОбластьТаблицы = ТабличныйДокумент.Область(Параметры.НачальнаяСтрока, 1,
		ТабличныйДокумент.ВысотаТаблицы, ТабличныйДокумент.ШиринаТаблицы);
	
	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(ОбластьТаблицы);
	ПостроительЗапроса.ДобавлениеПредставлений = ТипДобавленияПредставлений.НеДобавлять;
	ПостроительЗапроса.ЗаполнитьНастройки();
	
	Попытка
		
		ПостроительЗапроса.Выполнить();
		ТаблицаДанныхExcel = ПостроительЗапроса.Результат.Выгрузить();
		
	Исключение
		
		ФайловаяСистема.УдалитьВременныйФайл(ИмяВременногоФайла);
		ЗаписатьСобытияВЖурналРегистрации(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось установить прочитать Excel файл %1 по причине:
			|%2'"), ИмяВременногоФайла, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		
		Возврат Новый Структура("ДанныеПолучены, ТаблицаДанных", Ложь, Новый ТаблицаЗначений);
		
	КонецПопытки;
	
	ФайловаяСистема.УдалитьВременныйФайл(ИмяВременногоФайла);
	
	ТаблицаДанных = СформироватьДанныеЗагрузкиExcel(Параметры, СообщатьОПрогрессе, ТаблицаДанныхExcel);
	
	Возврат Новый Структура("ДанныеПолучены, ТаблицаДанных", Истина, ТаблицаДанных);
	
КонецФункции

Функция СформироватьДанныеЗагрузкиExcel(Параметры, СообщатьОПрогрессе, ТаблицаДанныхExcel)
	
	Если СообщатьОПрогрессе Тогда
		СообщитьОПодготовкеДанных(НСтр("ru = 'Обработка данных Excel'"));
	КонецЕсли;
	
	ПравилаПоискаПоРеквизитам = ПолучитьПравилаПоискаПоРеквизитам();
	СтруктураНастроек = Справочники.НастройкиСоответствийПолейЗагружаемыхДанных.ПолучитьСтруктуруНастроек(
		Параметры.Настройка);
	Параметры.Вставить("СтруктураНастроек", СтруктураНастроек);
	
	Запрос = Новый Запрос;
	Запрос.Текст = СформироватьЗапросДанныхExcel(СтруктураНастроек, ПравилаПоискаПоРеквизитам,
		Параметры.ТаблицаДанных, ТаблицаДанныхExcel);
	
	Запрос.УстановитьПараметр("ТаблицаДанныхExcel", ТаблицаДанныхExcel);
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаДанныхExcel = РезультатЗапроса.Выгрузить();
	
	ТаблицаДанных = Параметры.ТаблицаДанных;
	СоздаватьПриНеобходимости = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "СоздаватьПриНеобходимости", Ложь);
	
	ДополнитьТаблицуДанныхExcel(ТаблицаДанных, ТаблицаДанныхExcel, СтруктураНастроек,
		ПравилаПоискаПоРеквизитам, СоздаватьПриНеобходимости);
	
	Возврат ТаблицаДанных;
	
КонецФункции

Процедура ДополнитьТаблицуДанныхExcel(ТаблицаДанных, ТаблицаДанныхExcel, СтруктураНастроек, ПравилаПоискаПоРеквизитам, СоздаватьПриНеобходимости)
	
	НачатьТранзакцию();
	
	Попытка;
		
		Для Каждого ТекущаяСтрока Из ТаблицаДанныхExcel Цикл
			
			НоваяСтрока = ТаблицаДанных.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
			
			Для Каждого ТекущаяСтрокаНастройки Из СтруктураНастроек.ДанныеШапки Цикл
				
				ПравилоПоискаРеквизита = ПравилаПоискаПоРеквизитам.Получить(ТекущаяСтрокаНастройки.ПравилоПоиска);
				ИмяРеквизита = ТекущаяСтрокаНастройки.ИмяРеквизита;
				Если ПравилоПоискаРеквизита = Неопределено
					И НЕ ТекущаяСтрокаНастройки.ПравилоПоиска = Перечисления.ПравилаПоискаОбъектов.ПроизвольныйАлгоритм Тогда
					
					НоваяСтрока[ИмяРеквизита] = ПривестиЗначениеПоТипу(
						ТекущаяСтрока[ТекущаяСтрокаНастройки.ИмяКолонкиЗначения],
						ТекущаяСтрокаНастройки.ТипДанных,
						ТекущаяСтрокаНастройки.ПравилоПоиска);
						
				ИначеЕсли СоздаватьПриНеобходимости И Не ЗначениеЗаполнено(НоваяСтрока[ИмяРеквизита])
					И ТекущаяСтрокаНастройки.СоздаватьПриНеобходимости Тогда
					
					НоваяСтрока[ИмяРеквизита] = ОбщегоНазначенияУПОСервер.ВыполнитьПользовательскуюФункцию(
						ТекущаяСтрокаНастройки.ПроизвольныйАлгоритм, НоваяСтрока, ТекущаяСтрока);
				Иначе
					// Действий не требуется.
				КонецЕсли;
				
			КонецЦикла;
			
			Для Каждого ТекущаяТабЧасть Из СтруктураНастроек.ДанныеТабЧастей Цикл
				
				Для Каждого ТекущаяСтрокаНастройки Из ТекущаяТабЧасть.Значение Цикл
					
					ПравилоПоискаРеквизита = ПравилаПоискаПоРеквизитам.Получить(ТекущаяСтрокаНастройки.ПравилоПоиска);
					ИмяРеквизита = СтрШаблон("%1_%2", ТекущаяТабЧасть.Ключ, ТекущаяСтрокаНастройки.ИмяРеквизита);
					
					Если ПравилоПоискаРеквизита = Неопределено
						И НЕ ТекущаяСтрокаНастройки.ПравилоПоиска  = Перечисления.ПравилаПоискаОбъектов.ПроизвольныйАлгоритм Тогда
						
						НоваяСтрока[ИмяРеквизита] = ПривестиЗначениеПоТипу(
							ТекущаяСтрока[ТекущаяСтрокаНастройки.ИмяКолонкиЗначения],
							ТекущаяСтрокаНастройки.ТипДанных,
							ТекущаяСтрокаНастройки.ПравилоПоиска);
							
					ИначеЕсли СоздаватьПриНеобходимости И Не ЗначениеЗаполнено(НоваяСтрока[ИмяРеквизита])
							И ТекущаяСтрокаНастройки.СоздаватьПриНеобходимости Тогда
						
						НоваяСтрока[ИмяРеквизита] = ОбщегоНазначенияУПОСервер.ВыполнитьПользовательскуюФункцию(
							ТекущаяСтрокаНастройки.ПроизвольныйАлгоритм, НоваяСтрока, ТекущаяСтрока);
					Иначе
						// Действий не требуется.
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ЗаписатьСобытияВЖурналРегистрации(
			СтрШаблон(НСтр("ru='Ошибка загрузки рабочего времени.%1%2';
				|en = 'Error loading working time.%1%2'"),
			Символы.ПС, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		
		Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		
	КонецПопытки;
	
КонецПроцедуры

Функция СформироватьЗапросДанныхExcel(СтруктураНастроек, ПравилаПоискаПоРеквизитам, ТаблицаДанных, ТаблицаДанныхExcel)
	
	ТекстЗапроса = "";
	
	МассивПолей = Новый Массив;
	Для Каждого ТекущаяКолонка Из ТаблицаДанныхExcel.Колонки Цикл
		МассивПолей.Добавить(ТекущаяКолонка.Имя);
	КонецЦикла;
	
	МассивПолейЗапроса = Новый Массив;
	СформироватьМассивПолейЗапроса(МассивПолейЗапроса, МассивПолей, "ТаблицаДанныхExcel");
	ТекстЗапроса = СформироватьТекстТаблицыЗапроса(
		МассивПолейЗапроса, "&ТаблицаДанныхExcel", "ТаблицаДанныхExcel", Истина, "ТаблицаДанныхExcel");
	
	МассивСоединений = Новый Массив;
	СформироватьСоединенияЗапросаExcel(МассивПолейЗапроса, МассивСоединений, СтруктураНастроек, ПравилаПоискаПоРеквизитам, ТаблицаДанныхExcel);
	
	СоединенияЗапроса = СтрСоединить(МассивСоединений, Символы.ПС);
	ТекстЗапроса = СтрШаблон("%1%2%3", ТекстЗапроса, Символы.ПС, СформироватьТекстТаблицыЗапроса(
		МассивПолейЗапроса, "ТаблицаДанныхExcel", "ТаблицаДанныхExcel", Ложь, , СоединенияЗапроса));
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура СформироватьСоединенияЗапросаExcel(МассивПолейЗапроса, МассивСоединений, СтруктураНастроек, ПравилаПоискаПоРеквизитам, ТаблицаДанных)
	
	Для Каждого ТекущаяСтрока Из СтруктураНастроек.ДанныеШапки Цикл
		
		ПравилоПоискаРеквизита = ПравилаПоискаПоРеквизитам.Получить(ТекущаяСтрока.ПравилоПоиска);
		Если ПравилоПоискаРеквизита <> Неопределено Тогда
			
			СформироватьСоединенияЗапроса(МассивПолейЗапроса, МассивСоединений, ПравилоПоискаРеквизита,
				ТекущаяСтрока.ИмяРеквизита, ТекущаяСтрока.ИмяКолонкиЗначения, ТекущаяСтрока.ТипДанных, "ТаблицаДанныхExcel", ТаблицаДанных);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ТекущаяТабЧасть Из СтруктураНастроек.ДанныеТабЧастей Цикл
		
		Для Каждого ТекущаяСтрока Из ТекущаяТабЧасть.Значение Цикл
			
			ПравилоПоискаРеквизита = ПравилаПоискаПоРеквизитам.Получить(ТекущаяСтрока.ПравилоПоиска);
			Если ПравилоПоискаРеквизита <> Неопределено Тогда
				
				СформироватьСоединенияЗапроса(МассивПолейЗапроса, МассивСоединений, ПравилоПоискаРеквизита,
					СтрШаблон("%1_%2", ТекущаяТабЧасть.Ключ, ТекущаяСтрока.ИмяРеквизита),
					ТекущаяСтрока.ИмяКолонкиЗначения, ТекущаяСтрока.ТипДанных, "ТаблицаДанныхExcel", ТаблицаДанных);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти //ПрочитатьДанныхExcel

#Область ЗагрузитьДанныеExcel

Функция ЗагрузитьДанныеExcel(Параметры, СообщатьОПрогрессе)
	
	Если СообщатьОПрогрессе Тогда
		СообщитьОПодготовкеДанных(НСтр("ru = 'Чтение данных Excel'"));
	КонецЕсли;
	
	ДанныеФайла = Параметры.ДанныеФайла;
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Параметры.РасширениеФайла);
	ДанныеФайла.Записать(ИмяВременногоФайла);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Прочитать(ИмяВременногоФайла, СпособЧтенияЗначенийТабличногоДокумента.Текст);
	ОбластьТаблицы = ТабличныйДокумент.Область(Параметры.НачальнаяСтрока, 1,
		ТабличныйДокумент.ВысотаТаблицы, ТабличныйДокумент.ШиринаТаблицы);
	
	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(ОбластьТаблицы);
	ПостроительЗапроса.ДобавлениеПредставлений = ТипДобавленияПредставлений.НеДобавлять;
	ПостроительЗапроса.ЗаполнитьНастройки();
	
	Попытка
		
		ПостроительЗапроса.Выполнить();
		ТаблицаДанныхExcel = ПостроительЗапроса.Результат.Выгрузить();
	Исключение
		
		ФайловаяСистема.УдалитьВременныйФайл(ИмяВременногоФайла);
		ЗаписатьСобытияВЖурналРегистрации(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось установить прочитать Excel файл %1 по причине:
			|%2'"), ИмяВременногоФайла, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		
		Возврат Новый Структура("ДанныеПолучены, ТаблицаДанных", Ложь, Новый ТаблицаЗначений);
		
	КонецПопытки;
	
	ФайловаяСистема.УдалитьВременныйФайл(ИмяВременногоФайла);
	
	СформированныеДокументы = Новый Массив;
	ТаблицаДанных = СформироватьДанныеЗагрузкиExcel(Параметры, СообщатьОПрогрессе, ТаблицаДанныхExcel);
	
	СформироватьРегистрациюРабочегоВремени(Параметры, СообщатьОПрогрессе, СформированныеДокументы, ТаблицаДанных);
	
	Возврат Новый Структура("ДанныеЗагружены, СформированныеДокументы", Истина, СформированныеДокументы);
	
КонецФункции

Процедура СформироватьРегистрациюРабочегоВремени(Параметры, СообщатьОПрогрессе, СформированныеДокументы, ТаблицаДанных)
	
	Если СообщатьОПрогрессе Тогда
		СообщитьОПодготовкеДанных(НСтр("ru = 'Подготовка к формированию документов'"));
	КонецЕсли;
	
	ДанныеШапки = ТаблицаДанных.Скопировать();
	ДанныеШапки.Свернуть(СтрСоединить(Параметры.СтруктураНастроек.ДанныеШапки.ВыгрузитьКолонку("ИмяРеквизита"), ","));
	
	ПараметрыСообщенияОПрогрессе = ПараметрыСообщенияОПрогрессе(ДанныеШапки);
	
	Для Каждого ТекущаяСтрока Из ДанныеШапки Цикл
		
		Если СообщатьОПрогрессе Тогда
			ОповеститьОПрогрессе(ПараметрыСообщенияОПрогрессе);
		КонецЕсли;
		
		СтруктураДанных = РегистрацияРабочегоВремениСервер.ПолучитьСтруктуруРегистрацииРабочегоВремени();
		ЗаполнитьЗначенияСвойств(СтруктураДанных, ТекущаяСтрока);
		
		Для Каждого ТекущаяТабЧасть Из Параметры.СтруктураНастроек.ДанныеТабЧастей Цикл
			
			РеквизитыТабЧасти = ТекущаяТабЧасть.Значение.ВыгрузитьКолонку("ИмяРеквизита");
			
			ДанныеПоиска = ТаблицаДанных.НайтиСтроки(ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТекущаяСтрока));
			Для Каждого СтрокаПоиска Из ДанныеПоиска Цикл
				
				НоваяСтрока = СтруктураДанных.РабочееВремя.Добавить();
				Для Каждого ТекущийРеквизит Из РеквизитыТабЧасти Цикл
					НоваяСтрока[ТекущийРеквизит] = СтрокаПоиска[СтрШаблон("%1_%2", ТекущаяТабЧасть.Ключ, ТекущийРеквизит)];
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
		СформированныйДокумент = РегистрацияРабочегоВремениСервер.СформироватьРегистрациюРабочегоВремени(СтруктураДанных);
		СформированныеДокументы.Добавить(СформированныйДокумент);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти //ЗагрузитьДанныеExcel

Функция СформироватьТекстТаблицыЗапроса(МассивПолейЗапроса, ИмяТаблицы, СинонимТаблицы,
										ВременнаяТаблица = Ложь, ИмяВременнойТаблицы = "", Соединения = "", Условия = "")
	
	ТекстТаблицыЗапроса = СтрШаблон("ВЫБРАТЬ%1%2%1%3ИЗ%1%4%5 КАК %6%1%7%8%9",
		Символы.ПС, СтрСоединить(МассивПолейЗапроса, СтрШаблон(",%1", Символы.ПС)),
		?(ВременнаяТаблица, СтрШаблон("Поместить %1%2", ИмяВременнойТаблицы, Символы.ПС), Символы.ПС),
		Символы.Таб, ИмяТаблицы, СинонимТаблицы, Соединения, Условия, ?(ВременнаяТаблица, СтрШаблон("%1;%1", Символы.ПС), ""));
	
	Возврат ТекстТаблицыЗапроса;
	
КонецФункции

Процедура СформироватьМассивПолейЗапроса(МассивПолейЗапроса, МассивПолей, СинонимТаблицы)
	
	Для Каждого ТекущееПоле Из МассивПолей Цикл
		МассивПолейЗапроса.Добавить(СтрШаблон("%1%2.%3 КАК %3", Символы.Таб, СинонимТаблицы, ТекущееПоле));
	КонецЦикла;
	
КонецПроцедуры

Процедура СформироватьСоединенияЗапроса(МассивПолейЗапроса, МассивСоединений, ПравилоПоискаРеквизита,
										ИмяРеквизита, ИмяКолонкиЗначения, ТипРеквизита, ИмяТаблицы, ТаблицаДанных)
	
	Для Каждого ТекущийТип Из ТипРеквизита.Типы() Цикл
		
		ОбъектМетаданных = ИнтерфейсODataСлужебный.ОбъектМетаданныхПоТипуСсылки(ТекущийТип);
		Если ОбщегоНазначения.ЭтоОбъектСсылочногоТипа(ОбъектМетаданных) Тогда
			
			МассивПолейЗапроса.Добавить(СтрШаблон("%1%2.Ссылка КАК %3", Символы.Таб, ОбъектМетаданных.Имя, ИмяРеквизита));
			МассивСоединений.Добавить(СтрШаблон("%1%1ЛЕВОЕ СОЕДИНЕНИЕ %2 КАК %3%4%1%1ПО %5.%6 ПОДОБНО %7",
				Символы.Таб, ОбъектМетаданных.ПолноеИмя(), ОбъектМетаданных.Имя, Символы.ПС, ИмяТаблицы,
				ИмяКолонкиЗначения, СтрШаблон("%1 Выразить (%2.%3 КАК СТРОКА(%4))",
				"""%"" + ", ОбъектМетаданных.Имя, ПравилоПоискаРеквизита.Имя, ОбъектМетаданных[ПравилоПоискаРеквизита.Длина])));
			//Если ПравилоПоискаРеквизита.Имя = "Код" И ТаблицаДанных.Колонки[ИмяКолонкиЗначения].ТипЗначения.СодержитТип(Тип("Число")) Тогда
			//	Для Каждого Строка Из ТаблицаДанных Цикл
			//		Строка[ИмяКолонкиЗначения] = Формат(Строка[ИмяКолонкиЗначения], "ЧЦ=" + ОбъектМетаданных[ПравилоПоискаРеквизита.Длина] + "; ЧВН=; ЧГ=0");
			//	КонецЦикла;
			//КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьПравилаПоискаПоРеквизитам()
	
	ПравилаПоискаПоРеквизитам = Новый Соответствие;
	ПравилаПоискаПоРеквизитам.Вставить(Перечисления.ПравилаПоискаОбъектов.Наименование,
		Новый Структура("Имя, Длина", "Наименование", "ДлинаНаименования"));
	ПравилаПоискаПоРеквизитам.Вставить(Перечисления.ПравилаПоискаОбъектов.Код,
		Новый Структура("Имя, Длина", "Код", "ДлинаКода"));
	ПравилаПоискаПоРеквизитам.Вставить(Перечисления.ПравилаПоискаОбъектов.Номер,
		Новый Структура("Имя, Длина", "Номер", "ДлинаНомера"));
	
	Возврат ПравилаПоискаПоРеквизитам;
	
КонецФункции

Функция ПривестиЗначениеПоТипу(ТекущееЗначение, Тип, ПравилоПоиска)
	
	Значение = Неопределено;
	
	Если ПравилоПоиска = Перечисления.ПравилаПоискаОбъектов.Идентификатор Тогда
		Значение = НайтиСсылкуПоGUID(ТекущееЗначение);
	Иначе
		
		ТипДанных = Тип.Типы().Получить(0);
		Если ТипДанных = Тип("Строка") Тогда
			Значение = ТекущееЗначение;
		ИначеЕсли ТипДанных = Тип("Дата") Тогда
			Значение = СтроковыеФункцииКлиентСервер.СтрокаВДату(ТекущееЗначение);
		ИначеЕсли ТипДанных = Тип("Число") Тогда
			Значение = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ТекущееЗначение);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

Функция НайтиСсылкуПоGUID(Знач GUID)
	
	ЭтоМассив = ТипЗнч(GUID) = Тип("Массив");
	
	Если ЭтоМассив Тогда
		МассивGUID = GUID;
	Иначе
		МассивGUID = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(GUID);
	КонецЕсли;
	
	Результат = Неопределено;
	
	МассивМетаданных = Новый Массив;
	МассивМетаданных.Добавить(Справочники);
	МассивМетаданных.Добавить(Документы);
	МассивМетаданных.Добавить(ПланыВидовХарактеристик);
	МассивМетаданных.Добавить(ПланыСчетов);
	МассивМетаданных.Добавить(ПланыВидовРасчета);
	МассивМетаданных.Добавить(ПланыОбмена);
	МассивМетаданных.Добавить(БизнесПроцессы);
	МассивМетаданных.Добавить(Задачи);
	
	МассивТипов = Новый Массив;
	Для Каждого ТекущийОбъект Из МассивМетаданных Цикл
		Для Каждого ТекущийТип Из ТекущийОбъект.ТипВсеСсылки().Типы() Цикл
			МассивТипов.Добавить(ТекущийТип);
		КонецЦикла;
	КонецЦикла;
	
	ТаблицаСсылок = Новый ТаблицаЗначений;
	ТаблицаСсылок.Колонки.Добавить("GUID", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(36)));
	ТаблицаСсылок.Колонки.Добавить("Ссылка" , Новый ОписаниеТипов(МассивТипов));
	
	Для Каждого ТекущийОбъект Из МассивМетаданных Цикл
		
		Для Каждого ТекущийМенеджер Из ТекущийОбъект Цикл
			
			Для Каждого ТекущийGUID Из МассивGUID Цикл
				
				Попытка
					НоваяСтрока = ТаблицаСсылок.Добавить();
					НоваяСтрока.Ссылка = ТекущийМенеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(ТекущийGUID));
					НоваяСтрока.GUID = ТекущийGUID;
				Исключение
				КонецПопытки;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	ТаблицаСсылок.Ссылка КАК Ссылка,
		|	ТаблицаСсылок.GUID КАК GUID
		|ПОМЕСТИТЬ ВТ
		|ИЗ
		|	&ТаблицаСсылок КАК ТаблицаСсылок
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ.Ссылка КАК Ссылка,
		|	ВТ.GUID КАК GUID
		|ИЗ
		|	ВТ КАК ВТ
		|ГДЕ
		|   НЕ ВТ.Ссылка.ПометкаУдаления ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("ТаблицаСсылок", ТаблицаСсылок);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Если ЭтоМассив Тогда
			Результат = РезультатЗапроса.Выгрузить();
		Иначе
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			ВыборкаДетальныеЗаписи.Следующий();
			Результат = ВыборкаДетальныеЗаписи.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
