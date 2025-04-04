﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ПоказатьОписаниеФункции", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует описание функции или группы функций.
// 
// Параметры:
// 	Ссылка - СправочникСсылка.__ПользовательскиеФункции.
// 
&НаСервере
Процедура ПоказатьОписаниеФункцииСервер(Ссылка)
	
	Если Ссылка.ЭтоГруппа Тогда
		
		ТекстОписания = СтрШаблон(НСтр("ru='#В группе: %1';en='#In Group: %1'"), Символы.ПС);
		
		Выборка = Справочники.ПользовательскиеФункции.Выбрать(Ссылка);
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ЭтоГруппа Тогда
				Продолжить;
			КонецЕсли;
			
			ОписаниеСКомментариями = СтрЗаменить(СокрЛП(Выборка.Описание), Символы.ПС, СтрШаблон("%1// ", Символы.ПС));
			Если СокрЛП(Выборка.Описание) = "" Тогда
				ОписаниеФункции = НСтр("ru='// <нет описания>';en='// <No description>'");
			Иначе	
				ОписаниеФункции = СтрШаблон("// %1", ОписаниеСКомментариями);
			КонецЕсли;
			
			ОбщегоНазначенияУПОСервер.ДобавитьСтрокуКТексту(ТекстОписания, ОписаниеФункции);
			СтруктураЗаголовка = Справочники.ПользовательскиеФункции.ПолучитьНазваниеПодпрограммыСПараметрами(Выборка.Ссылка);
			ОбщегоНазначенияУПОСервер.ДобавитьСтрокуКТексту(ТекстОписания, СтруктураЗаголовка.ЗаголовокФункции + Символы.ПС);
		КонецЦикла;
		
		ПолеОписания = ТекстОписания;
	Иначе
		СтруктураЗаголовка = Справочники.ПользовательскиеФункции.ПолучитьНазваниеПодпрограммыСПараметрами(Ссылка);
		
		Элементы.ДекорацияНазваниеСПараметрами.Заголовок = СтруктураЗаголовка.НазваниеСПараметрами;
		ПолеОписания = СтрШаблон("%1%2%3", СтруктураЗаголовка.ОписаниеПараметров, Символы.ПС, СокрЛП(Ссылка.КодПодпрограммы));
	КонецЕсли;
	
	Элементы.Описание.Видимость = Не Ссылка.ЭтоГруппа;
	Элементы.ГруппаШапкаФункции.Видимость = Не Ссылка.ЭтоГруппа;
	Элементы.ГруппаПодвалФункции.Видимость = Не Ссылка.ЭтоГруппа;
	
КонецПроцедуры

// Обработчик ожидания активизации строки.
// 
&НаКлиенте
Процедура ПоказатьОписаниеФункции()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОписаниеФункцииСервер(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

