﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.Отбор) = Тип("Структура")
		И Параметры.Отбор.Свойство("Объект1") Тогда
		// форма открывается из Объекта 1
		
		Элементы.ТипСоответствия.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти //ОбработчикиСобытийФормы

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипСоответствияПриИзменении(Элемент)
	
	ТипСоответствияПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти //ОбработчикиСобытийЭлементовШапкиФормы

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ТипСоответствияПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(ТипСоответствия) Тогда
		ОбщегоНазначенияУПОСервер.ИзменитьЭлементОтбораСписка(Список, "ТипСоответствия", ТипСоответствия, Истина);
	Иначе
		ОбщегоНазначенияУПОСервер.УдалитьЭлементОтбораСписка(Список, "ТипСоответствия");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти //СлужебныеПроцедурыИФункции
