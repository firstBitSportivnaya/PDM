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

// Зарегистрировать пользователя бота в системе.
// 
// Параметры:
//  БотСсылка - СправочникСсылка.Боты - Бот ссылка
//  НастройкаИнтеграции - СправочникСсылка.НастройкиИнтеграции - Настройка интеграции
//  ЗначениеСистемы - Строка, Число - Значение системы
//  ИдентификаторСообщения - Число - Идентификатор сообщения чата бота
//  ОтветПользователя - Строка - Выбор варианта авторизации / код проверки / телефон / почта / ФИО пользователя
Процедура ЗарегистрироватьПользователяБотаВСистеме(БотСсылка, НастройкаИнтеграции,
	ЗначениеСистемы, ИдентификаторСообщения, ОтветПользователя = "") Экспорт
	
	ЗначениеСистемыСтрокой = Строка(ЗначениеСистемы);
	
	ЗначениеСистемыМассив = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ЗначениеСистемыСтрокой);
	ДанныеСоответвийПользователей = РегистрыСведений
		.СоответствияПользователейСистем.ПолучитьТаблицуСоответствийПользователейСистем(
		ЗначениеСистемыМассив, Новый Массив, НастройкаИнтеграции);
	
	Если ДанныеСоответвийПользователей.Количество()
		И ДанныеСоответвийПользователей[0].Зарегистрирован Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НастройкаИнтеграции"	, НастройкаИнтеграции);
	Запрос.УстановитьПараметр("ИдентификаторЧата"	, ЗначениеСистемыСтрокой);
	Запрос.Текст = "ВЫБРАТЬ
	|	РегистрацияПользователейБота.ВыборВариантаАвторизации КАК ВыборВариантаАвторизации,
	|	РегистрацияПользователейБота.ЗапросТелефонаПочты КАК ЗапросТелефонаПочты,
	|	РегистрацияПользователейБота.ВыбранныйВариант КАК ВыбранныйВариант,
	|	РегистрацияПользователейБота.КодПроверки КАК КодПроверки,
	|	РегистрацияПользователейБота.ОповещениеОПодтверждении КАК ОповещениеОПодтверждении,
	|	РегистрацияПользователейБота.ЗапросФИО КАК ЗапросФИО,
	|	РегистрацияПользователейБота.ОповещениеОНекорректномФИО КАК ОповещениеОНекорректномФИО,
	|	РегистрацияПользователейБота.ОповещениеОбОжидании КАК ОповещениеОбОжидании,
	|	РегистрацияПользователейБота.ОповещениеОНедоступностиФункционала КАК ОповещениеОНедоступностиФункционала,
	|	РегистрацияПользователейБота.ОповещенииОбОкончании КАК ОповещенииОбОкончании
	|ИЗ
	|	РегистрСведений.РегистрацияПользователейБота КАК РегистрацияПользователейБота
	|ГДЕ
	|	РегистрацияПользователейБота.НастройкаИнтеграции = &НастройкаИнтеграции
	|	И РегистрацияПользователейБота.ИдентификаторЧата = &ИдентификаторЧата";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		НачатьАвторизациюПользователя(БотСсылка, НастройкаИнтеграции, ЗначениеСистемыСтрокой);
	Иначе
		
		ВыборкаРезультатаЗапроса = РезультатЗапроса.Выбрать();
		ВыборкаРезультатаЗапроса.Следующий();
		
		ВыполнитьПоследовательностьДействийПриАвторизацииРегистрацииПользователя(ВыборкаРезультатаЗапроса,
			ИдентификаторСообщения, БотСсылка, НастройкаИнтеграции, ЗначениеСистемыСтрокой, ОтветПользователя);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ДляВызоваИзДругихПодсистем

// Добавить запись.
// 
// Параметры:
//  ПараметрыЗаписи - Структура - набор параметров Для записи. Ключи:
//   * НастройкаИнтеграции - СправочникСсылка.НастройкиИнтеграции - Настройка интеграции
//   * ИдентификаторЧата - Строка - Идентификатор чата бота
//   * ЗапросФИО - Число, Неопределено - Идентификатор сообщения запроса ФИО ботом у пользователя
//   * ОповещениеОбОжидании - Идентификатор сообщения об оповещении пользователя ожидания подтверждения регистрации
//   * ОповещенииОбОкончании - Число, Неопределено - Идентификатор сообщения об оповещении пользователя окончания регистрации
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
//   * ИдентификаторЧата - Строка - Идентификатор чата бота
//   * ЗапросФИО - Число, Неопределено - Идентификатор сообщения запроса ФИО ботом у пользователя
//   * ОповещениеОбОжидании - Идентификатор сообщения об оповещении пользователя ожидания подтверждения регистрации
//   * ОповещенииОбОкончании - Число, Неопределено - Идентификатор сообщения об оповещении пользователя окончания регистрации
Процедура ИзменитьЗапись(ПараметрыЗаписи) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	
	Если ЗначениеЗаполнено(ПараметрыЗаписи.НастройкаИнтеграции) Тогда
		НаборЗаписей.Отбор.НастройкаИнтеграции.Установить(ПараметрыЗаписи.НастройкаИнтеграции);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыЗаписи.ИдентификаторЧата) Тогда
		НаборЗаписей.Отбор.ИдентификаторЧата.Установить(ПараметрыЗаписи.ИдентификаторЧата);
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
//   * ИдентификаторЧата - Строка - Идентификатор чата бота
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

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьПоследовательностьДействийПриАвторизацииРегистрацииПользователя(ВыборкаРезультатаЗапроса,
	ИдентификаторСообщения, БотСсылка, НастройкаИнтеграции, ЗначениеСистемыСтрокой, ОтветПользователя)
	
	Если ЗначениеЗаполнено(ВыборкаРезультатаЗапроса.ВыборВариантаАвторизации)
		И Не ЗначениеЗаполнено(ВыборкаРезультатаЗапроса.ЗапросТелефонаПочты)
		И ИдентификаторСообщения >= ВыборкаРезультатаЗапроса.ВыборВариантаАвторизации Тогда
		
		НачатьПроверкуПоНомеруТелефонаПочте(БотСсылка, НастройкаИнтеграции, ЗначениеСистемыСтрокой, ОтветПользователя);
		
	ИначеЕсли ЗначениеЗаполнено(ВыборкаРезультатаЗапроса.ЗапросТелефонаПочты)
		И Не ЗначениеЗаполнено(ВыборкаРезультатаЗапроса.ОповещениеОПодтверждении)
		И Не ЗначениеЗаполнено(ВыборкаРезультатаЗапроса.ЗапросФИО)
		И ИдентификаторСообщения > ВыборкаРезультатаЗапроса.ЗапросТелефонаПочты Тогда
		
		РезультатПоиска = НайтиПользователяПоТелефонуПочте(НастройкаИнтеграции,
			ВыборкаРезультатаЗапроса.ВыбранныйВариант, ЗначениеСистемыСтрокой, ИдентификаторСообщения, ОтветПользователя);
		
		Если РезультатПоиска <> Неопределено Тогда
			ОтправитьКодПодтвержденияНаТелефонПочту(БотСсылка, НастройкаИнтеграции, РезультатПоиска,
				ВыборкаРезультатаЗапроса.ВыбранныйВариант, ЗначениеСистемыСтрокой, ОтветПользователя);
		Иначе
			НачатьРегистрациюПользователяВСистеме(БотСсылка, НастройкаИнтеграции, ЗначениеСистемыСтрокой);
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ВыборкаРезультатаЗапроса.ОповещениеОПодтверждении)
		И Не ЗначениеЗаполнено(ВыборкаРезультатаЗапроса.ОповещенииОбОкончании)
		И ИдентификаторСообщения > ВыборкаРезультатаЗапроса.ОповещениеОПодтверждении Тогда
		
		ПроверитьКодПодтвержденияПриАвторизации(БотСсылка,
			НастройкаИнтеграции, ЗначениеСистемыСтрокой, ВыборкаРезультатаЗапроса.КодПроверки, ОтветПользователя)
		
	ИначеЕсли ЗначениеЗаполнено(ВыборкаРезультатаЗапроса.ЗапросФИО)
		И Не ЗначениеЗаполнено(ВыборкаРезультатаЗапроса.ОповещениеОбОжидании)
		И ИдентификаторСообщения > ВыборкаРезультатаЗапроса.ЗапросФИО Тогда
		
		НачатьСозданиеПользователяПриРегистрации(БотСсылка, НастройкаИнтеграции,
			ИдентификаторСообщения, ВыборкаРезультатаЗапроса.ОповещениеОНекорректномФИО, ЗначениеСистемыСтрокой, ОтветПользователя);
		
	ИначеЕсли ЗначениеЗаполнено(ВыборкаРезультатаЗапроса.ОповещениеОбОжидании)
		И Не ЗначениеЗаполнено(ВыборкаРезультатаЗапроса.ОповещениеОНедоступностиФункционала)
		И ИдентификаторСообщения > ВыборкаРезультатаЗапроса.ОповещениеОбОжидании Тогда
		
		ОповеститьПользователяОНедоступностиФункционала(БотСсылка, НастройкаИнтеграции, ЗначениеСистемыСтрокой);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьАвторизациюПользователя(БотСсылка, НастройкаИнтеграции, ЗначениеСистемы)
	
	ДанныеСообщения = Новый Структура;
	ДанныеСообщения.Вставить("ТипСообщения"	, Перечисления.ТипыСообщенийTelegramBot.Авторизация);
	ТекстСообщения = ИнтеграцияСБотамиСлужебныйСервер.ПолучитьТекстСообщенияПредопределенногоОтвета(
		БотСсылка, Перечисления.ТипыПредопределенныхОтветовБота.ВыборВариантаАвторизации);
	ДанныеСообщения.Вставить("Содержимое", ТекстСообщения);
	
	Результат = ИнтеграцияСБотамиСервер.ВыполнитьОтправкуСообщения(
		БотСсылка, ДанныеСообщения, ЗначениеСистемы);
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("НастройкаИнтеграции"		, НастройкаИнтеграции);
	ПараметрыЗаписи.Вставить("ИдентификаторЧата"		, ЗначениеСистемы);
	ПараметрыЗаписи.Вставить("ВыборВариантаАвторизации"	, Результат.Идентификатор);
	
	ДобавитьЗапись(ПараметрыЗаписи);
	
КонецПроцедуры

Процедура НачатьПроверкуПоНомеруТелефонаПочте(БотСсылка, НастройкаИнтеграции, ЗначениеСистемы, ВариантАвторизации)
	
	ВариантАвторизацииСсылка = Перечисления.ВариантыАвторизацииБота[ВариантАвторизации];
	
	Если Не ЗначениеЗаполнено(ВариантАвторизацииСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если ВариантАвторизацииСсылка = Перечисления.ВариантыАвторизацииБота.ПоТелефону Тогда
		ТекстСообщения = ИнтеграцияСБотамиСлужебныйСервер.ПолучитьТекстСообщенияПредопределенногоОтвета(
			БотСсылка, Перечисления.ТипыПредопределенныхОтветовБота.ЗапросТелефона);
	Иначе
		ТекстСообщения = ИнтеграцияСБотамиСлужебныйСервер.ПолучитьТекстСообщенияПредопределенногоОтвета(
			БотСсылка, Перечисления.ТипыПредопределенныхОтветовБота.ЗапросПочты);
	КонецЕсли;
	
	ДанныеСообщения = Новый Структура;
	ДанныеСообщения.Вставить("ТипСообщения"	, Перечисления.ТипыСообщенийTelegramBot.ОтправкаСообщения);
	ДанныеСообщения.Вставить("Содержимое", ТекстСообщения);
	
	Результат = ИнтеграцияСБотамиСервер.ВыполнитьОтправкуСообщения(
		БотСсылка, ДанныеСообщения, ЗначениеСистемы);
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("НастройкаИнтеграции"	, НастройкаИнтеграции);
	ПараметрыЗаписи.Вставить("ИдентификаторЧата"	, ЗначениеСистемы);
	ПараметрыЗаписи.Вставить("ВыбранныйВариант"		, ВариантАвторизацииСсылка);
	ПараметрыЗаписи.Вставить("ЗапросТелефонаПочты"	, Результат.Идентификатор);
	
	ИзменитьЗапись(ПараметрыЗаписи);
	
КонецПроцедуры

Функция НайтиПользователяПоТелефонуПочте(НастройкаИнтеграции,
	ВариантАвторизации, ЗначениеСистемы, ИдентификаторСообщения, ТелефонПочта)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Значение", НРег(ТелефонПочта));
	Если ВариантАвторизации = Перечисления.ВариантыАвторизацииБота.ПоТелефону Тогда
		Запрос.УстановитьПараметр("ВидКИ", Справочники.ВидыКонтактнойИнформации.ТелефонПользователя);
		Запрос.УстановитьПараметр("ТипКИ", Перечисления.ТипыКонтактнойИнформации.Телефон);
	Иначе
		Запрос.УстановитьПараметр("ВидКИ", Справочники.ВидыКонтактнойИнформации.EmailПользователя);
		Запрос.УстановитьПараметр("ТипКИ", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ПользователиКонтактнаяИнформация.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
	|ГДЕ
	|	ПользователиКонтактнаяИнформация.Вид = &ВидКИ
	|	И ПользователиКонтактнаяИнформация.Тип = &ТипКИ
	|	И НРЕГ(ПользователиКонтактнаяИнформация.Представление) ПОДОБНО &Значение";
	
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаРезультатаЗапроса.Следующий() Тогда
		РезультатПоиска = ВыборкаРезультатаЗапроса.Ссылка;
		
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("НастройкаИнтеграции"	, НастройкаИнтеграции);
		ПараметрыЗаписи.Вставить("ТипИдентификации"		, Перечисления.ТипыИдентификацииСистем.Идентификатор);
		ПараметрыЗаписи.Вставить("ЗначениеСистемы"		, ЗначениеСистемы);
		ПараметрыЗаписи.Вставить("Пользователь"			, РезультатПоиска);
		ПараметрыЗаписи.Вставить("Зарегистрирован"		, Ложь);
		
		РегистрыСведений.СоответствияПользователейСистем.ДобавитьЗапись(ПараметрыЗаписи);
	Иначе
		РезультатПоиска = Неопределено;
	КонецЕсли;
	
	Возврат РезультатПоиска;
	
КонецФункции

Процедура ОтправитьКодПодтвержденияНаТелефонПочту(БотСсылка, НастройкаИнтеграции,
	Пользователь, ВариантАвторизации, ЗначениеСистемы, ТелефонПочта)
	
	ДлинаКода = 16;
	КодПроверки = ИнтеграцияСБотамиСлужебныйСервер.СгенерироватьКодПроверки(ДлинаКода);
	
	ИнтеграцияСБотамиСлужебныйСервер.ОтправитьПисьмоВерификацииПользователю(БотСсылка, КодПроверки, ТелефонПочта);
	
	ДанныеСообщения = Новый Структура;
	ДанныеСообщения.Вставить("ТипСообщения"	, Перечисления.ТипыСообщенийTelegramBot.ОтправкаСообщения);
	ШаблонСообщения = ИнтеграцияСБотамиСлужебныйСервер.ПолучитьТекстСообщенияПредопределенногоОтвета(
		БотСсылка, Перечисления.ТипыПредопределенныхОтветовБота.ОповещениеОПодтверждении);
	
	ТекстСообщения = СтрШаблон(ШаблонСообщения, ?(ВариантАвторизации = Перечисления.ВариантыАвторизацииБота.ПоПочте,
		"почтовый ящик", "телефон"), ТелефонПочта);
	ДанныеСообщения.Вставить("Содержимое", ТекстСообщения);
	
	Результат = ИнтеграцияСБотамиСервер.ВыполнитьОтправкуСообщения(
		БотСсылка, ДанныеСообщения, ЗначениеСистемы);
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("НастройкаИнтеграции"		, НастройкаИнтеграции);
	ПараметрыЗаписи.Вставить("ИдентификаторЧата"		, ЗначениеСистемы);
	ПараметрыЗаписи.Вставить("КодПроверки"				, КодПроверки);
	ПараметрыЗаписи.Вставить("ОповещениеОПодтверждении"	, Результат.Идентификатор);
	
	ИзменитьЗапись(ПараметрыЗаписи);
	
КонецПроцедуры

Процедура ПроверитьКодПодтвержденияПриАвторизации(БотСсылка,
	НастройкаИнтеграции, ЗначениеСистемы, КодПроверки, ОтветПользователя)
	
	Если КодПроверки <> ОтветПользователя Тогда
		ДанныеСообщения = Новый Структура;
		ДанныеСообщения.Вставить("ТипСообщения"	, Перечисления.ТипыСообщенийTelegramBot.ОтправкаСообщения);
		ТекстСообщения = ИнтеграцияСБотамиСлужебныйСервер.ПолучитьТекстСообщенияПредопределенногоОтвета(
			БотСсылка, Перечисления.ТипыПредопределенныхОтветовБота.НекорректныйКод);
		ДанныеСообщения.Вставить("Содержимое", ТекстСообщения);
		
		Результат = ИнтеграцияСБотамиСервер.ВыполнитьОтправкуСообщения(
			БотСсылка, ДанныеСообщения, ЗначениеСистемы);
		
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("НастройкаИнтеграции"	, НастройкаИнтеграции);
	ПараметрыЗаписи.Вставить("ТипИдентификации"		, Перечисления.ТипыИдентификацииСистем.Идентификатор);
	ПараметрыЗаписи.Вставить("ЗначениеСистемы"		, ЗначениеСистемы);
	ПараметрыЗаписи.Вставить("Зарегистрирован"		, Истина);
	
	РегистрыСведений.СоответствияПользователейСистем.ИзменитьЗапись(ПараметрыЗаписи);
	
	РегистрыСведений.СоответствияПользователейСистем.ОповеститьПользователяОбОкончанииРегистрации(
		БотСсылка, НастройкаИнтеграции, ЗначениеСистемы);
	
КонецПроцедуры

Процедура НачатьРегистрациюПользователяВСистеме(БотСсылка, НастройкаИнтеграции, ЗначениеСистемы)
	
	ДанныеСообщения = Новый Структура;
	ДанныеСообщения.Вставить("ТипСообщения"	, Перечисления.ТипыСообщенийTelegramBot.ОтправкаСообщения);
	ТекстСообщения = ИнтеграцияСБотамиСлужебныйСервер.ПолучитьТекстСообщенияПредопределенногоОтвета(
		БотСсылка, Перечисления.ТипыПредопределенныхОтветовБота.ЗапросФИО);
	ДанныеСообщения.Вставить("Содержимое", ТекстСообщения);
	
	Результат = ИнтеграцияСБотамиСервер.ВыполнитьОтправкуСообщения(
		БотСсылка, ДанныеСообщения, ЗначениеСистемы);
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("НастройкаИнтеграции"	, НастройкаИнтеграции);
	ПараметрыЗаписи.Вставить("ИдентификаторЧата"	, ЗначениеСистемы);
	ПараметрыЗаписи.Вставить("ЗапросФИО"			, Результат.Идентификатор);
	
	ИзменитьЗапись(ПараметрыЗаписи);
	
КонецПроцедуры

Процедура НачатьСозданиеПользователяПриРегистрации(БотСсылка, НастройкаИнтеграции,
	ИдентификаторСообщения, ОповещениеОНекорректномФИО, ЗначениеСистемыСтрокой, ФИОПользователя)
	
	Если Не ЗначениеЗаполнено(ОповещениеОНекорректномФИО)
		Или ИдентификаторСообщения > ОповещениеОНекорректномФИО Тогда
		ПроверкаУспешна = ПроверитьФИОПользователяНаНедопустимыеСимволы(
			БотСсылка, НастройкаИнтеграции, ЗначениеСистемыСтрокой, ФИОПользователя);
	Иначе
		ПроверкаУспешна = Ложь;
	КонецЕсли;
	
	Если Не ПроверкаУспешна Тогда
		Возврат;
	КонецЕсли;
	
	ПользовательОбъект = Справочники.Пользователи.СоздатьЭлемент();
	
	ПользовательОбъект.Наименование		= ФИОПользователя;
	ПользовательОбъект.Недействителен	= Ложь;
	ПользовательОбъект.Служебный		= Ложь;
	ПользовательОбъект.Подготовлен		= Истина;
	
	ПользовательОбъект.Записать();
	
	СообщитьОтветственнымОРегистрируемомПользователе(БотСсылка, НастройкаИнтеграции, ЗначениеСистемыСтрокой, ФИОПользователя);
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("НастройкаИнтеграции"	, НастройкаИнтеграции);
	ПараметрыЗаписи.Вставить("ТипИдентификации"		, Перечисления.ТипыИдентификацииСистем.Идентификатор);
	ПараметрыЗаписи.Вставить("ЗначениеСистемы"		, ЗначениеСистемыСтрокой);
	ПараметрыЗаписи.Вставить("Пользователь"			, ПользовательОбъект.Ссылка);
	
	РегистрыСведений.СоответствияПользователейСистем.ДобавитьЗапись(ПараметрыЗаписи);
	
КонецПроцедуры

Процедура ОповеститьПользователяОНедоступностиФункционала(БотСсылка, НастройкаИнтеграции, ЗначениеСистемы)
	
	ДанныеСообщения = Новый Структура;
	ДанныеСообщения.Вставить("ТипСообщения"	, Перечисления.ТипыСообщенийTelegramBot.ОтправкаСообщения);
	ТекстСообщения = ИнтеграцияСБотамиСлужебныйСервер.ПолучитьТекстСообщенияПредопределенногоОтвета(
		БотСсылка, Перечисления.ТипыПредопределенныхОтветовБота.НедоступностьФункционала);
	ДанныеСообщения.Вставить("Содержимое"		, ТекстСообщения);
	
	Результат = ИнтеграцияСБотамиСервер.ВыполнитьОтправкуСообщения(
		БотСсылка, ДанныеСообщения, ЗначениеСистемы);
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("НастройкаИнтеграции"	, НастройкаИнтеграции);
	ПараметрыЗаписи.Вставить("ИдентификаторЧата"	, ЗначениеСистемы);
	ПараметрыЗаписи.Вставить("ОповещениеОНедоступностиФункционала", Результат.Идентификатор);
	
	ИзменитьЗапись(ПараметрыЗаписи);
	
КонецПроцедуры

Функция ПроверитьФИОПользователяНаНедопустимыеСимволы(БотСсылка, НастройкаИнтеграции, ЗначениеСистемы, ФИОПользователя)
	
	ТекстОшибкиНеверныйФормат = "Система ожидает сообщение в формате [Фамилия Имя Отчество] с разделителями в виде пробела";
	ТекстОшибкиНедопустимыеСимволы = "ФИО не может содержать ";
	РезультатПроверки = "";
	
	ИсходнаяСтрока = СокрЛП(ФИОПользователя);
	Если СтрДлина(ИсходнаяСтрока) > 0 Тогда
		МассивФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИсходнаяСтрока, " ", Истина, Истина);
		Если МассивФИО.Количество() <> 3
			И Не (МассивФИО.Количество() = 4 И СтрНачинаетсяС(НРег(МассивФИО[3]), "оглы")) Тогда
			РезультатПроверки = ТекстОшибкиНеверныйФормат;
		КонецЕсли;
		
		Если ПустаяСтрока(РезультатПроверки) Тогда
			Для Инкремент = 1 по СтрДлина(ИсходнаяСтрока) Цикл
				Символ = НРег(Сред(ИсходнаяСтрока, Инкремент, 1));
				Если Найти("1234567890", Символ) Тогда
					РезультатПроверки = ТекстОшибкиНедопустимыеСимволы + "числа";
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ПустаяСтрока(РезультатПроверки) Тогда
			Для Инкремент = 1 по СтрДлина(ИсходнаяСтрока) Цикл
				Символ = НРег(Сред(ИсходнаяСтрока, Инкремент, 1));
				Если Найти("`~!@#$%^&*()-_=+""'№;:?.,<>/\\[]{}", Символ) Тогда
					РезультатПроверки = ТекстОшибкиНедопустимыеСимволы + "символы";
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПустаяСтрока(РезультатПроверки) Тогда
		ДанныеСообщения = Новый Структура;
		ДанныеСообщения.Вставить("ТипСообщения"	, Перечисления.ТипыСообщенийTelegramBot.ОтправкаСообщения);
		ДанныеСообщения.Вставить("Содержимое", РезультатПроверки);
		
		Результат = ИнтеграцияСБотамиСервер.ВыполнитьОтправкуСообщения(
			БотСсылка, ДанныеСообщения, ЗначениеСистемы);
		
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("НастройкаИнтеграции"	, НастройкаИнтеграции);
		ПараметрыЗаписи.Вставить("ИдентификаторЧата"	, ЗначениеСистемы);
		ПараметрыЗаписи.Вставить("ОповещениеОНекорректномФИО", Результат.Идентификатор);
		
		ИзменитьЗапись(ПараметрыЗаписи);
		
		Возврат Ложь;
	Иначе
		ДанныеСообщения = Новый Структура;
		ДанныеСообщения.Вставить("ТипСообщения"	, Перечисления.ТипыСообщенийTelegramBot.ОтправкаСообщения);
		ТекстСообщения = ИнтеграцияСБотамиСлужебныйСервер.ПолучитьТекстСообщенияПредопределенногоОтвета(
			БотСсылка, Перечисления.ТипыПредопределенныхОтветовБота.ОжиданиеРегистрации);
		ДанныеСообщения.Вставить("Содержимое", ТекстСообщения);
		
		Результат = ИнтеграцияСБотамиСервер.ВыполнитьОтправкуСообщения(
			БотСсылка, ДанныеСообщения, ЗначениеСистемы);
		
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("НастройкаИнтеграции"	, НастройкаИнтеграции);
		ПараметрыЗаписи.Вставить("ИдентификаторЧата"	, ЗначениеСистемы);
		ПараметрыЗаписи.Вставить("ОповещениеОбОжидании"	, Результат.Идентификатор);
		
		ИзменитьЗапись(ПараметрыЗаписи);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура СообщитьОтветственнымОРегистрируемомПользователе(БотСсылка, НастройкаИнтеграции, ЗначениеСистемы, ФИОПользователя)
	
	МассивНужныхПользователей = ОбщегоНазначенияУПОСервер.ПолучитьПредопределенноеЗначение(
		"ОтветственныеПодтверждающиеРегистрациюПользователейБота");
	
	ДанныеСообщения = Новый Структура;
	ДанныеСообщения.Вставить("ТипСообщения"	, Перечисления.ТипыСообщенийTelegramBot.ОтправкаСообщения);
	ШаблонСообщения = ИнтеграцияСБотамиСлужебныйСервер.ПолучитьТекстСообщенияПредопределенногоОтвета(
		БотСсылка, Перечисления.ТипыПредопределенныхОтветовБота.ОповещениеОтветственныхОНовом);
	ТекстСообщения = СтрШаблон(ШаблонСообщения, ФИОПользователя, ЗначениеСистемы);
	ДанныеСообщения.Вставить("Содержимое", ТекстСообщения);
	
	Для Каждого ЭлементПолучатель Из МассивНужныхПользователей Цикл
		Результат = ИнтеграцияСБотамиСервер.ВыполнитьОтправкуСообщения(БотСсылка, ДанныеСообщения, ЭлементПолучатель);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли