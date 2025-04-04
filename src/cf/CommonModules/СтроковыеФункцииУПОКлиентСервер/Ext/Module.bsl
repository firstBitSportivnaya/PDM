﻿////////////////////////////////////////////////////////////////////////////////
// Работа со строками (клиент, сервер): Модуль содержит методы работы со строками.

#Область ПрограммныйИнтерфейс

// Разбирает строку с разделителями и упаковывает значения в массив.
// 
// Параметры:
//  ИсходнаяСтрока  - Строка
//  Разделитель     - Строка
//  ПоНарастающей   - Булево (По умолчанию = Ложь) .
//
// ВозвращаемоеЗначение:
//  Массив
//
Функция РазобратьСтрокуСРазделителями(ИсходнаяСтрока, Разделитель, ПоНарастающей = Ложь) Экспорт
	
	Результат = Новый Массив;
	
	Список = ОбщегоНазначенияУПОКлиентСервер.РазобратьСтрокуСРазделителями(ИсходнаяСтрока, Разделитель);
	Если ПоНарастающей Тогда
		НарастающаяСтрока = "";
		Для Каждого СтрокаСписка Из Список Цикл
			
			НарастающаяСтрока = ?(ПустаяСтрока(НарастающаяСтрока),
				СтрокаСписка, СтрШаблон("%1.%2", НарастающаяСтрока, СтрокаСписка));
			Результат.Добавить(НарастающаяСтрока);
		КонецЦикла; 
	Иначе
		Результат = Список;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает текст с добавлением/удаление разделителя "|".
// 
// Параметры:
//  Текст    - Строка - Обрабатываемый текст.
//  Добавить - Булево - Признак добавления/удаления вертикальной черты.
// 
// Возвращаемое значение:
//  Строка - Результат обработки строки.
//
Функция УбратьДобавитьВертикальнуюЧерту(Текст, Добавить = Ложь) Экспорт
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(Текст);
	КоличествоСтрок = ТекстовыйДокумент.КоличествоСтрок();
	
	Если Добавить Тогда
		
		Для Сч = 1 По КоличествоСтрок Цикл
		
			ТекущаяСтрока = ТекстовыйДокумент.ПолучитьСтроку(Сч);
			
			Если Сч = 1 Тогда
				ТекущаяСтрока = """" + ТекущаяСтрока;
			Иначе
				
				ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, """", """""");
				ТекущаяСтрока = СтрШаблон("|%1", ТекущаяСтрока);
				
				Если Сч = КоличествоСтрок Тогда
					ТекущаяСтрока = СтрШаблон("%1%2", ТекущаяСтрока, """");
				КонецЕсли;
			КонецЕсли;
			
			ТекстовыйДокумент.ЗаменитьСтроку(Сч, ТекущаяСтрока);
		КонецЦикла;
	Иначе
		
		Для Сч = 1 По КоличествоСтрок Цикл
		
			ТекущаяСтрока = ТекстовыйДокумент.ПолучитьСтроку(Сч);
			
			Если Сч = 1 Тогда
				ТекущаяСтрока = Сред(ТекущаяСтрока, 2);
			ИначеЕсли Сч = КоличествоСтрок Тогда
				ТекущаяСтрока = Сред(ТекущаяСтрока, 1, СтрДлина(ТекущаяСтрока) - 1);
			КонецЕсли;
			
			ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, """""", """");
			ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "|", "");
			
			ТекстовыйДокумент.ЗаменитьСтроку(Сч, ТекущаяСтрока);
		КонецЦикла;
	КонецЕсли;
	
	Результат = ТекстовыйДокумент.ПолучитьТекст();
	Результат = Сред(Результат, 1, СтрДлина(Результат) - 1);
	
	Возврат Результат;
	
КонецФункции

#Область Склонения

// Получить склонение представления месяца.
// 
// Параметры:
//  ЧисловоеЗначение - Число - Числовое значение
//  СВерхнегоРегистра - Булево - С верхнего регистра
// 
// Возвращаемое значение:
//  Строка - Получить склонение представления месяца
Функция ПолучитьСклонениеПредставленияМесяца(ЧисловоеЗначение, СВерхнегоРегистра = Ложь) Экспорт
	
	Представление = "";
	КодЯзыка = ОбщегоНазначенияУПОВызовСервера.ПолучитьЯзыкТекущегоПользователя().КодЯзыка;
	
	Если ЧисловоеЗначение = 1 Тогда
		Если КодЯзыка = "en" Тогда
			Представление = "month";
		Иначе
			Представление = "месяц";
		КонецЕсли;
	ИначеЕсли 2 <= ЧисловоеЗначение И ЧисловоеЗначение <= 4 Тогда
		Если КодЯзыка = "en" Тогда
			Представление = "months";
		Иначе
			Представление = "месяца";
		КонецЕсли;
	Иначе
		Если КодЯзыка = "en" Тогда
			Представление = "months";
		Иначе
			Представление = "месяцев";
		КонецЕсли;
	КонецЕсли;
	
	Если СВерхнегоРегистра Тогда
		Представление = ТРег(Представление);
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

// Получить склонение представления года.
// 
// Параметры:
//  ЧисловоеЗначение - Число - Числовое значение
//  СВерхнегоРегистра - Булево - С верхнего регистра
// 
// Возвращаемое значение:
//  Строка - Получить склонение представления года
Функция ПолучитьСклонениеПредставленияГода(ЧисловоеЗначение, СВерхнегоРегистра = Ложь) Экспорт
	
	Представление = "";
	КодЯзыка = ОбщегоНазначенияУПОВызовСервера.ПолучитьЯзыкТекущегоПользователя().КодЯзыка;
	
	Если КодЯзыка = "en" Тогда
		Если ЧисловоеЗначение = 1 Тогда
			Представление = "year";
		Иначе
			Представление = "years";
		КонецЕсли;
	Иначе
		Если ЧисловоеЗначение < 10 Тогда
			Если ЧисловоеЗначение = 1 Тогда
				Представление = "год";
			ИначеЕсли 2 <= ЧисловоеЗначение И ЧисловоеЗначение <= 4 Тогда
				Представление = "года"
			Иначе
				Представление = "лет";
			КонецЕсли;
		Иначе
			
			ИсключенияЛет = Новый Массив;
			ИсключенияЛет.Добавить("11");
			ИсключенияЛет.Добавить("12");
			ИсключенияЛет.Добавить("13");
			ИсключенияЛет.Добавить("14");
			
			ПоследнееЧислоЗначения = Прав(Строка(ЧисловоеЗначение), 1);
			ПоследнееДваЧислаЗначения = Прав(Строка(ЧисловоеЗначение), 2);
			
			Если ПоследнееЧислоЗначения = "1" И ИсключенияЛет.Найти(ПоследнееДваЧислаЗначения) = Неопределено Тогда
				Представление = "год";
			ИначеЕсли (ПоследнееЧислоЗначения = "2" Или ПоследнееЧислоЗначения = "3" Или ПоследнееЧислоЗначения = "4")
				И ИсключенияЛет.Найти(ПоследнееДваЧислаЗначения) = Неопределено Тогда
				Представление = "года";
			Иначе
				Представление = "лет";
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если СВерхнегоРегистра Тогда
		Представление = ТРег(Представление);
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти // Склонения

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
