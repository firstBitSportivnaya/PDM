﻿//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2024 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область СлужебныйПрограммныйИнтерфейс

// ЗагрузитьТесты
// 	Читает наборы тестов (тестовые модули) из расширений
// Параметры:
//  ПараметрыЗапускаТестов - см. ЮТФабрика.ПараметрыЗапуска
//
// Возвращаемое значение:
//  Массив из см. ЮТФабрикаСлужебный.ОписаниеТестовогоМодуля - Набор описаний тестовых модулей, которые содержат информацию о запускаемых тестах
Функция ЗагрузитьТесты(ПараметрыЗапускаТестов) Экспорт
	
	Результат = Новый Массив;
	
	ЮТФильтрацияСлужебный.УстановитьКонтекст(ПараметрыЗапускаТестов);
	
	Для Каждого МетаданныеМодуля Из ТестовыеМодули() Цикл
		
		ОписаниеТестовогоМодуля = ТестовыеНаборыМодуля(МетаданныеМодуля, ПараметрыЗапускаТестов);
		
		Если ОписаниеТестовогоМодуля = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Добавить(ОписаниеТестовогоМодуля);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// ПрочитатьНаборТестов
// 	Читает набор тестов из модуля
// Параметры:
//  МетаданныеМодуля - см. ЮТФабрикаСлужебный.ОписаниеМодуля
//
// Возвращаемое значение:
//  - Неопределено - Если это не тестовый модуль
//  - см. ЮТФабрикаСлужебный.ОписаниеТестовогоМодуля
Функция ИсполняемыеСценарииМодуля(Знач МетаданныеМодуля) Экспорт
	
	ЭтоТестовыйМодуль = Истина;
	ОписаниеТестовогоМодуля = ЮТФабрикаСлужебный.ОписаниеТестовогоМодуля(МетаданныеМодуля, Новый Массив);
	
	ЮТТестыСлужебный.ПередЧтениемСценариевМодуля(МетаданныеМодуля);
	
	ПолноеИмяМетода = МетаданныеМодуля.Имя + "." + ИмяМетодаСценариев();
	Ошибка = ЮТМетодыСлужебный.ВыполнитьМетод(ПолноеИмяМетода);
	
	Если Ошибка <> Неопределено Тогда
		
		ТипыОшибок = ЮТФабрикаСлужебный.ТипыОшибок();
		ТипОшибки = ЮТРегистрацияОшибокСлужебный.ТипОшибки(Ошибка, ПолноеИмяМетода);
		
		Если ТипОшибки = ТипыОшибок.ТестНеРеализован Тогда
			ЭтоТестовыйМодуль = Ложь;
			Ошибка = Неопределено;
		ИначеЕсли ТипОшибки = ТипыОшибок.МалоПараметров Тогда
			Ошибка = ЮТМетодыСлужебный.ВыполнитьМетод(ПолноеИмяМетода, ЮТКоллекции.ЗначениеВМассиве(Неопределено));
			ЮТОбщий.СообщитьПользователю("Используется устаревшая сигнатура метода `ИсполняемыеСценарии`, метод не должен принимать параметров.");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Ошибка <> Неопределено Тогда
		
		НаборПоУмолчанию = ЮТФабрикаСлужебный.ОписаниеТестовогоНабора(МетаданныеМодуля.Имя);
		ЮТРегистрацияОшибокСлужебный.ЗарегистрироватьОшибкуЧтенияТестов(НаборПоУмолчанию, "Ошибка формирования списка тестовых методов", Ошибка);
		ОписаниеТестовогоМодуля.НаборыТестов.Добавить(НаборПоУмолчанию);
		
	ИначеЕсли ЭтоТестовыйМодуль Тогда
		
		ЮТТестыСлужебный.ПослеЧтенияСценариевМодуля();
		Сценарии = ЮТТестыСлужебный.СценарииМодуля();
		
		УдалитьНастройкиМодуляИзПервогоНабора(Сценарии); // TODO Нужен рефакторинг
		
		ОписаниеТестовогоМодуля.НаборыТестов = ЮТФильтрацияСлужебный.ОтфильтроватьТестовыеНаборы(Сценарии.ТестовыеНаборы, МетаданныеМодуля);
		ОписаниеТестовогоМодуля.НастройкиВыполнения = Сценарии.НастройкиВыполнения;
		
	Иначе
		
		ОписаниеТестовогоМодуля = Неопределено;
		
	КонецЕсли;
	
	Возврат ОписаниеТестовогоМодуля;
	
КонецФункции

// ЭтоТестовыйМодуль
//   Проверяет, является ли модуль модулем с тестами
// Параметры:
//  МетаданныеМодуля - Структура - Описание метаданных модуля, см. ЮТФабрикаСлужебный.ОписаниеМодуля
//
// Возвращаемое значение:
//  Булево - Этот модуль содержит тесты
Функция ЭтоТестовыйМодуль(МетаданныеМодуля) Экспорт
	
	Если МетаданныеМодуля.Глобальный Тогда
		Возврат Ложь;
	КонецЕсли;
	
#Если Сервер Тогда
	Возврат ЮТМетодыСлужебный.МетодМодуляСуществует(МетаданныеМодуля.Имя, ИмяМетодаСценариев());
#КонецЕсли
	
#Если ТолстыйКлиентУправляемоеПриложение ИЛИ ТонкийКлиент Тогда
	Если МетаданныеМодуля.КлиентУправляемоеПриложение Тогда
		Возврат ЮТМетодыСлужебный.МетодМодуляСуществует(МетаданныеМодуля.Имя, ИмяМетодаСценариев());
	КонецЕсли;
#КонецЕсли
	
#Если ТолстыйКлиентОбычноеПриложение Тогда
	Если МетаданныеМодуля.КлиентОбычноеПриложение Тогда
		Возврат ЮТМетодыСлужебный.МетодМодуляСуществует(МетаданныеМодуля.Имя, ИмяМетодаСценариев());
	КонецЕсли;
#КонецЕсли
	
	Если МетаданныеМодуля.Сервер Тогда
		//@skip-check unknown-method-property
		Возврат ЮТЧитательСлужебныйВызовСервера.ЭтоТестовыйМодуль(МетаданныеМодуля);
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяМетодаСценариев()
	
	Возврат "ИсполняемыеСценарии";
	
КонецФункции

// ТестовыеМодули
//  Возвращает описания модулей, содержащих тесты
// Возвращаемое значение:
//  Массив из см. ЮТМетаданныеСлужебныйВызовСервера.МетаданныеМодуля - Тестовые модули
Функция ТестовыеМодули()
	
	ТестовыеМодули = Новый Массив;
	
	//@skip-check unknown-method-property
	МодулиРасширения = ЮТМетаданныеСлужебныйВызовСервера.МодулиРасширений();
	
	Для Каждого ОписаниеМодуля Из МодулиРасширения Цикл
		
		Если ЮТФильтрацияСлужебный.ЭтоПодходящийМодуль(ОписаниеМодуля) И ЭтоТестовыйМодуль(ОписаниеМодуля) Тогда
			
			ТестовыеМодули.Добавить(ОписаниеМодуля);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТестовыеМодули;
	
КонецФункции

Функция ТестовыеНаборыМодуля(МетаданныеМодуля, ПараметрыЗапуска)
	
	// TODO Фильтрация по путям
	ОписаниеМодуля = Неопределено;
	
#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
	Если МетаданныеМодуля.КлиентОбычноеПриложение ИЛИ МетаданныеМодуля.КлиентУправляемоеПриложение Тогда
		
		ОписаниеМодуля = ИсполняемыеСценарииМодуля(МетаданныеМодуля);
		
	ИначеЕсли МетаданныеМодуля.Сервер Тогда
		
		ОписаниеМодуля = ЮТЧитательСлужебныйВызовСервера.ИсполняемыеСценарииМодуля(МетаданныеМодуля);
		ЮТЛогированиеСлужебный.ВывестиСерверныеСообщения();
		
	КонецЕсли;
#ИначеЕсли Сервер Тогда
	Если МетаданныеМодуля.Сервер Тогда
		
		ОписаниеМодуля = ИсполняемыеСценарииМодуля(МетаданныеМодуля);
		
	Иначе
		
		ВызватьИсключение "Чтение списка тестов модуля в недоступном контексте";
		
	КонецЕсли;
#ИначеЕсли Клиент Тогда
	Если МетаданныеМодуля.КлиентУправляемоеПриложение Тогда
		
		ОписаниеМодуля = ИсполняемыеСценарииМодуля(МетаданныеМодуля);
		
	ИначеЕсли МетаданныеМодуля.Сервер Тогда
		
		ОписаниеМодуля = ЮТЧитательСлужебныйВызовСервера.ИсполняемыеСценарииМодуля(МетаданныеМодуля);
		ЮТЛогированиеСлужебный.ВывестиСерверныеСообщения();
		
	КонецЕсли;
#КонецЕсли
	
	Возврат ОписаниеМодуля;
	
КонецФункции

Процедура УдалитьНастройкиМодуляИзПервогоНабора(СценарииМодуля)
	
	НастройкиВыполнения = ЮТКоллекции.СкопироватьРекурсивно(СценарииМодуля.НастройкиВыполнения);
	
	СценарииМодуля.НастройкиВыполнения.Очистить();
	
	СценарииМодуля.НастройкиВыполнения = НастройкиВыполнения;
	
КонецПроцедуры

#КонецОбласти
