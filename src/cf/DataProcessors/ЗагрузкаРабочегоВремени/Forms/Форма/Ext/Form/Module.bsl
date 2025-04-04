﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем мКэшРеквизитовФормы; // Хранит текущие значения реквизитов формы.

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьТекущиеЗначенияРеквизитовФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НастройкиСоответствийПолейExcelПриИзменении(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастройкиСоответствийПолейExcelПриИзмененииПродолжение", ЭтотОбъект);
	Если ТаблицаДанныхExcel.Количество() Тогда
		
		ПоказатьВопрос(ОписаниеОповещения,
			НСтр("ru='Таблица данных будет очищена. Продолжить?';
			|en = 'The data table will be cleared. Continue?'"), РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаДанныхExcelНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СвойстваДиалога = ПолучитьСвойстваДиалогаВыбораФайла();
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Заголовок = СвойстваДиалога.Заголовок;
	ПараметрыЗагрузки.Диалог.Фильтр = СвойстваДиалога.Фильтр;
	
	ФайловаяСистемаКлиент.ЗагрузитьФайлы(
		Новый ОписаниеОповещения("ЗагрузитьИзExcelЗавершение", ЭтотОбъект),
		ПараметрыЗагрузки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаДанныхExcel

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСформированныеДокументы

&НаКлиенте
Процедура СформированныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СформированныеДокументы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.Значение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрочитатьДанныеФайла(Команда)
	
	Если Не ОбязательныеПоляЗаполнены() Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьТаблицуПродолжение", ЭтотОбъект);
	Если ТаблицаДанныхExcel.Количество() Тогда
		
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Данные будут перезаполнены. Продолжить?';
			|en = 'The data will be overfilled. Continue?'"), РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеФайла(Команда)
	
	Если Не ОбязательныеПоляЗаполнены() Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗагрузитьДанныеФайлаПродолжение", ЭтотОбъект),
		НСтр("ru='Данные файла будут загружены. Продолжить?';
		|en = 'The file data will be uploaded. Continue?'"), РежимДиалогаВопрос.ДаНет, 60);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаСКэшемРеквизитовФормы

// Процедура заполняет кэш реквизитов формы данными объекта.
// 
&НаКлиенте 
Процедура ЗаполнитьТекущиеЗначенияРеквизитовФормы()
	
	мКэшРеквизитовФормы = Новый Структура;
	мКэшРеквизитовФормы.Вставить("НастройкиСоответствийПолейExcel");
	
	Для Каждого КлючИЗначение Из мКэшРеквизитовФормы Цикл
		мКэшРеквизитовФормы[КлючИЗначение.Ключ] = Объект[КлючИЗначение.Ключ];
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьТекущиеЗначенияРеквизитовФормы()

// Процедура добавляет в кэш реквизитов текущее значение заданного реквизита.
// 
// Параметры:
// 	ИмяРеквизита - Строка.
// 
&НаКлиенте
Процедура ДобавитьВКэш(ИмяРеквизита)
	
	мКэшРеквизитовФормы[ИмяРеквизита] = Объект[ИмяРеквизита];
	
КонецПроцедуры // ДобавитьВКэш()

// Процедура извлекает из кэша и присваивает объекту значение заданного реквизита.
// 
// Параметры:
// 	ИмяРеквизита - Строка.
// 
&НаКлиенте
Процедура ИзвлечьИзКэша(ИмяРеквизита)
	
	Объект[ИмяРеквизита] = мКэшРеквизитовФормы[ИмяРеквизита];
	
КонецПроцедуры // ИзвлечьИзКэша()

#КонецОбласти

#Область ОписанияОповещения

&НаКлиенте
Процедура НастройкиСоответствийПолейExcelПриИзмененииПродолжение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ДобавитьВКэш("НастройкиСоответствийПолейExcel");
		
		ТаблицаДанныхExcel.Очистить();
		СформироватьТаблицуДанныхПоНастройке("ТаблицаДанныхExcel",
			Объект.НастройкиСоответствийПолейExcel);
	Иначе
		ИзвлечьИзКэша("НастройкиСоответствийПолейExcel");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Функция ПолучитьСвойстваДиалогаВыбораФайла()
	
	Свойства = Новый Структура("Фильтр, Заголовок");
	Свойства.Заголовок = НСтр("ru = 'Выберите файл загрузки'; en='Select the download file'");
	Свойства.Фильтр = "Все файлы Excel (*.xls, *.xlsx)|*.xls; *.xlsx|"
		+ "Файлы Excel (*.xlsx)|*.xlsx|Файлы Excel 97-2003 (*.xls)|*.xls|";
	
	Возврат Свойства;
	
КонецФункции

&НаСервере
Процедура СформироватьТаблицуДанныхПоНастройке(ТаблицаДанных, Настройка)
	
	Если Не ЗначениеЗаполнено(ТаблицаДанных) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураНастроек = Справочники.НастройкиСоответствийПолейЗагружаемыхДанных.ПолучитьСтруктуруНастроек(
		Настройка);
	ДанныеШапки = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		СтруктураНастроек, "ДанныеШапки", Новый ТаблицаЗначений);
	ДанныеТабЧастей = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		СтруктураНастроек, "ДанныеТабЧастей", Новый Соответствие);
	
	// Удаление реквизитов формы
	МассивУдаляемыхЭлементов = Новый Массив;
	МассивУдаляемыхРеквизитов = Новый Массив;
	Для Каждого ТекущийЭлемент Из Элементы[ТаблицаДанных].ПодчиненныеЭлементы Цикл
		МассивУдаляемыхРеквизитов.Добавить(ТекущийЭлемент.ПутьКДанным);
		МассивУдаляемыхЭлементов.Добавить(ТекущийЭлемент);
	КонецЦикла;
	
	Для Каждого ТекущийЭлемент Из МассивУдаляемыхЭлементов Цикл
		Элементы.Удалить(ТекущийЭлемент);
	КонецЦикла;
	
	// Реквизиты формы
	МассивДобавляемыхРеквизитов = Новый Массив;
	Для Каждого ТекущаяСтрока Из ДанныеШапки Цикл
		
		ДобавитьРеквизитФормы(МассивДобавляемыхРеквизитов, ТекущаяСтрока.ИмяРеквизита,
			ТекущаяСтрока.ТипДанных, ТаблицаДанных);
	КонецЦикла;
	
	Для Каждого ТекущаяТабЧасть Из ДанныеТабЧастей Цикл
		
		Для Каждого ТекущаяСтрока Из ТекущаяТабЧасть.Значение Цикл
			
			ДобавитьРеквизитФормы(МассивДобавляемыхРеквизитов,
				СтрШаблон("%1_%2", ТекущаяТабЧасть.Ключ, ТекущаяСтрока.ИмяРеквизита),
				ТекущаяСтрока.ТипДанных, ТаблицаДанных);
		КонецЦикла;
	КонецЦикла;
	
	//
	ИзменитьРеквизиты(МассивДобавляемыхРеквизитов, МассивУдаляемыхРеквизитов);
	
	// Элементы формы
	Для Каждого ТекущаяСтрока Из ДанныеШапки Цикл
		ДобавитьЭлементФормы(ТекущаяСтрока.ИмяРеквизита, ТекущаяСтрока.ИмяРеквизита, ТаблицаДанных);
	КонецЦикла;
	
	Для Каждого ТекущаяТабЧасть Из ДанныеТабЧастей Цикл
		
		Для Каждого ТекущаяСтрока Из ТекущаяТабЧасть.Значение Цикл
			
			ДобавитьЭлементФормы(
				СтрШаблон("%1_%2", ТекущаяТабЧасть.Ключ, ТекущаяСтрока.ИмяРеквизита),
				СтрШаблон("%1.%2", ТекущаяТабЧасть.Ключ, ТекущаяСтрока.ИмяРеквизита),
				ТаблицаДанных);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьРеквизитФормы(МассивДобавляемыхРеквизитов, ИмяРеквизита, ТипДанных, ТаблицаДанных)
	
	МассивДобавляемыхРеквизитов.Добавить(Новый РеквизитФормы(ИмяРеквизита, ТипДанных, ТаблицаДанных));
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЭлементФормы(ИмяРеквизита, Заголовок, ТаблицаДанных)
	
	НовыйЭлемент = Элементы.Добавить(СтрШаблон("%1%2", ТаблицаДанных, ИмяРеквизита), Тип("ПолеФормы"), Элементы.Найти(ТаблицаДанных));
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = СтрШаблон("%1.%2", ТаблицаДанных, ИмяРеквизита);
	НовыйЭлемент.Заголовок = Заголовок;
	
КонецПроцедуры

&НаКлиенте
Функция ОбязательныеПоляЗаполнены()
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.НастройкиСоответствийПолейExcel) Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Настройки соответствий полей не выбраны';
			|en = 'Field matching settings are not selected'"),,
			"НастройкиСоответствийПолейExcel", "Объект.НастройкиСоответствийПолейExcel", Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ИмяФайлаДанныхExcel) Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Excel файл не выбран';
			|en = 'Excel file not selected'"),, "ИмяФайлаДанныхExcel", "Объект.ИмяФайлаДанныхExcel", Отказ);
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

#Область ПрочитатьДанныхExcel

&НаКлиенте
Процедура ЗагрузитьИзExcelЗавершение(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Или Не ПомещенныеФайлы.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	ПомещенныйФайл = ПомещенныеФайлы.Получить(0);
	
	Объект.ИмяФайлаДанныхExcel = ПомещенныйФайл.Имя;
	
	АдресФайла = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПомещенныйФайл, "Хранение", "");
	РасширениеФайла = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(
		ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПомещенныйФайл, "Имя", ""));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуПродолжение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Получение данных Excel'");
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ПодготовитьДанныеExcel(
			Новый Структура("ДанныеФайла, РасширениеФайла", АдресФайла, РасширениеФайла)),
			Новый ОписаниеОповещения("ПослеПодготовкиДанныхExcel", ЭтотОбъект), ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьДанныеExcel(ДополнительныеПараметры)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДанныеФайла", ПолучитьИзВременногоХранилища(ДополнительныеПараметры.ДанныеФайла));
	СтруктураПараметров.Вставить("РасширениеФайла", ДополнительныеПараметры.РасширениеФайла);
	СтруктураПараметров.Вставить("НачальнаяСтрока", НачальнаяСтрока);
	СтруктураПараметров.Вставить("СоздаватьПриНеобходимости", Ложь);
	СтруктураПараметров.Вставить("Настройка", Объект.НастройкиСоответствийПолейExcel);
	СтруктураПараметров.Вставить("ТаблицаДанных", ТаблицаДанныхExcel.Выгрузить().СкопироватьКолонки());
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("СтруктураПараметров", СтруктураПараметров);
	ПараметрыПроцедуры.Вставить("СообщатьОПрогрессе", Истина);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение данных Excel.'");
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"Обработки.ЗагрузкаРабочегоВремени.ПодготовитьДанныеExcelВФоне", ПараметрыПроцедуры);
	
	Возврат ДлительнаяОперация;
	
КонецФункции

&НаКлиенте
Процедура ПослеПодготовкиДанныхExcel(Результат, ДополнительныеПараметры) Экспорт
	
	// Отменено пользователем
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	Иначе
		ПослеПодготовкиДанныхExcelЗавершение(Результат.АдресРезультата);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеПодготовкиДанныхExcelЗавершение(АдресРезультата)
	
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресРезультата);
	Если Не ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатВыполнения, "ДанныеПолучены", Ложь) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Ошибка получения данных файла Excel.';
			|en = 'Error receiving Excel file data.'"));
	Иначе
		ТаблицаДанныхExcel.Загрузить(РезультатВыполнения.ТаблицаДанных);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти //ПрочитатьДанныхExcel

#Область ЗагрузитьДанныеФайла

&НаКлиенте
Процедура ЗагрузитьДанныеФайлаПродолжение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Получение данных Excel'");
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ЗагрузитьДанныеExcel(
			Новый Структура("ДанныеФайла, РасширениеФайла", АдресФайла, РасширениеФайла)),
			Новый ОписаниеОповещения("ПослеЗагрузкиДанныхExcel", ЭтотОбъект), ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьДанныеExcel(ДополнительныеПараметры)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДанныеФайла", ПолучитьИзВременногоХранилища(ДополнительныеПараметры.ДанныеФайла));
	СтруктураПараметров.Вставить("РасширениеФайла", ДополнительныеПараметры.РасширениеФайла);
	СтруктураПараметров.Вставить("НачальнаяСтрока", НачальнаяСтрока);
	СтруктураПараметров.Вставить("СоздаватьПриНеобходимости", Истина);
	СтруктураПараметров.Вставить("Настройка", Объект.НастройкиСоответствийПолейExcel);
	СтруктураПараметров.Вставить("ТаблицаДанных", ТаблицаДанныхExcel.Выгрузить().СкопироватьКолонки());
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("СтруктураПараметров", СтруктураПараметров);
	ПараметрыПроцедуры.Вставить("СообщатьОПрогрессе", Истина);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение данных Excel.'");
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"Обработки.ЗагрузкаРабочегоВремени.ЗагрузитьДанныеExcelВФоне", ПараметрыПроцедуры);
	
	Возврат ДлительнаяОперация;
	
КонецФункции

&НаКлиенте
Процедура ПослеЗагрузкиДанныхExcel(Результат, ДополнительныеПараметры) Экспорт
	
	// Отменено пользователем
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	Иначе
		ПослеЗагрузкиДанныхExcelЗавершение(Результат.АдресРезультата);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗагрузкиДанныхExcelЗавершение(АдресРезультата)
	
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресРезультата);
	Если Не ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатВыполнения, "ДанныеЗагружены", Ложь) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Ошибка загрузки данных файла Excel.'; en = ''"));
	КонецЕсли;
	
	СформированныеДокументы.Очистить();
	Для Каждого ТекущийДокумент Из РезультатВыполнения.СформированныеДокументы Цикл
		СформированныеДокументы.Добавить(ТекущийДокумент);
	КонецЦикла;
	
	ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Документы сформированы.';
		|en = 'The documents have been formed.'"));
	
КонецПроцедуры

#КонецОбласти //ЗагрузитьДанныеФайла

#КонецОбласти