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

Процедура ОбновлениеПредопределенных() Экспорт

	ЗаполнитьСправочникСертификатовИзМакета();

КонецПроцедуры

#КонецОбласти // ДляВызоваИзДругихПодсистем

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСправочникСертификатовИзМакета()

	ТабличныйДокументСертификаты = Справочники.Сертификаты.ПолучитьМакет("ЗаполнениеПредопределенных");

	ДеревоСертификатов = Новый ДеревоЗначений;
	ДеревоСертификатов.Колонки.Добавить("Наименование"			, ОбщегоНазначения.ОписаниеТипаСтрока(150));
	ДеревоСертификатов.Колонки.Добавить("ИмяПредопределенного"	, ОбщегоНазначения.ОписаниеТипаСтрока(150));
	ДеревоСертификатов.Колонки.Добавить("Компетенция"			, ОбщегоНазначения.ОписаниеТипаСтрока(150));

	ОбщегоНазначенияУПОСервер.ЗаполнитьДеревоЗначенийИзИерархическогоМакета(
		ТабличныйДокументСертификаты, ДеревоСертификатов, 4);

	СоздатьСертификатыИзДереваРекурсивно(ДеревоСертификатов.Строки);

КонецПроцедуры

Процедура СоздатьСертификатыИзДереваРекурсивно(СтрокиДерева, РодительСсылка = Неопределено)

	Для Каждого СтрокаСертификата Из СтрокиДерева Цикл

		ЭтоГруппа = СтрокаСертификата.Строки.Количество() > 0;

		СправочникСсылка = Справочники.Сертификаты.НайтиПоРеквизиту(
			"ИмяПредопределенного", СтрокаСертификата.ИмяПредопределенного);

		Если Не СправочникСсылка.Пустая() Тогда
			СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
			СправочникОбъект.Заблокировать();
		Иначе
			Если ЭтоГруппа Тогда
				СправочникОбъект = Справочники.Сертификаты.СоздатьГруппу();
			Иначе
				СправочникОбъект = Справочники.Сертификаты.СоздатьЭлемент();
			КонецЕсли;
			
			СправочникОбъект.ИмяПредопределенного = СтрокаСертификата.ИмяПредопределенного;
		КонецЕсли;

		СправочникОбъект.Наименование = СтрокаСертификата.Наименование;

		Если ЗначениеЗаполнено(РодительСсылка) Тогда
			СправочникОбъект.Родитель = РодительСсылка;
		КонецЕсли;
		
		Если Не ЭтоГруппа Тогда
			КомпетенцияСсылка = Справочники.Компетенции.НайтиПоРеквизиту(
				"ИмяПредопределенного", СтрокаСертификата.Компетенция);
			
			СправочникОбъект.Компетенция = КомпетенцияСсылка;
		КонецЕсли;
		
		СправочникОбъект.Записать();

		Если ЭтоГруппа Тогда
			СоздатьСертификатыИзДереваРекурсивно(СтрокаСертификата.Строки, СправочникОбъект.Ссылка);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли