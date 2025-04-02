﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Записывает таблицу настроек в данные регистра по указанным измерениям.
//
// Параметры:
//  ТаблицаНастроек - ТаблицаЗначений
//  Измерения - Структура:
//    * Пользователь - СправочникСсылка.Пользователи
//                   - СправочникСсылка.ВнешниеПользователи
//    * Вариант - СправочникСсылка.ВариантыОтчетов
//    * Подсистема - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//                 - СправочникСсылка.ИдентификаторыОбъектовРасширений
//  Ресурсы - Структура:
//    * Видимость - Булево
//    * БыстрыйДоступ - Булево
//  ПоверхСуществующих - Булево
//
// Возвращаемое значение:
//  РегистрСведенийНаборЗаписей.ПредопределенныеВариантыОтчетовВерсийРасширений
//
Функция Набор(ТаблицаНастроек, Измерения, Ресурсы, ПоверхСуществующих) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	Для Каждого КлючИЗначение Из Измерения Цикл
		ЭлементОтбора = НаборЗаписей.Отбор[КлючИЗначение.Ключ]; // ЭлементОтбора
		ЭлементОтбора.Установить(КлючИЗначение.Значение, Истина);
		
		ТаблицаНастроек.Колонки.Добавить(КлючИЗначение.Ключ);
		ТаблицаНастроек.ЗаполнитьЗначения(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из Ресурсы Цикл
		ТаблицаНастроек.Колонки.Добавить(КлючИЗначение.Ключ);
		ТаблицаНастроек.ЗаполнитьЗначения(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	
	Если Не ПоверхСуществующих Тогда
		НаборЗаписей.Прочитать();
		СтарыеЗаписи = НаборЗаписей.Выгрузить();
		ПоискПоИзмерениям = Новый Структура("Отчет, Вариант, ВерсияРасширений, КлючВарианта");
		Для Каждого СтараяЗапись Из СтарыеЗаписи Цикл
			ЗаполнитьЗначенияСвойств(ПоискПоИзмерениям, СтараяЗапись);
			Если ТаблицаНастроек.НайтиСтроки(ПоискПоИзмерениям).Количество() = 0 Тогда
				ЗаполнитьЗначенияСвойств(ТаблицаНастроек.Добавить(), СтараяЗапись);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	НаборЗаписей.Загрузить(ТаблицаНастроек);
	Возврат НаборЗаписей;
	
КонецФункции

#КонецОбласти

#КонецЕсли