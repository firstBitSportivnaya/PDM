﻿#Область ПрограммныйИнтерфейс

// Процедура создает запись справочника История интеграции с информацией о событии интеграции
//
// Параметры:
//	СтруктураЗаписиИстории - Структура - описание действия повлекшего ошибку
//	ЭтоЗагрузка - Булево - Истина если это Загрузка, Ложь если это Выгрузка
//
Процедура СоздатьСообщениеИсторииИнтеграции(СтруктураЗаписиИстории, ЭтоЗагрузка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДополнительноОбработатьЗапросыИнтеграцииПередЗаписьюВИсторию(СтруктураЗаписиИстории);
	
	НовоеСообщение = Справочники.ИсторияИнтеграции.СоздатьЭлемент();
	НовоеСообщение.ДатаИнтеграции = ТекущаяДатаСеанса();
	НовоеСообщение.ДатаИнтеграцииВМиллисекундах = ТекущаяУниверсальнаяДатаВМиллисекундах();
	НовоеСообщение.Код = Новый УникальныйИдентификатор();
	НовоеСообщение.Ошибка = ЗначениеЗаполнено(СтруктураЗаписиИстории.ОписаниеОшибки);
	НовоеСообщение.Пользователь = Пользователи.ТекущийПользователь();
	НовоеСообщение.ДлительностьОбмена = НовоеСообщение.ДатаИнтеграции - СтруктураЗаписиИстории.ДатаНачалаИнтеграции;
	НовоеСообщение.ДлительностьВызова = СтруктураЗаписиИстории.ДлительностьВызова;
	Если ЭтоЗагрузка Тогда
		Если НовоеСообщение.Ошибка Тогда
			НовоеСообщение.Статус = Перечисления.СтатусыИнтеграции.ОшибкаЗагрузки;
		Иначе
			НовоеСообщение.Статус = Перечисления.СтатусыИнтеграции.Загружено;
		КонецЕсли;
	Иначе
		Если НовоеСообщение.Ошибка Тогда
			НовоеСообщение.Статус = Перечисления.СтатусыИнтеграции.ОшибкаВыгрузки;
		Иначе
			НовоеСообщение.Статус = Перечисления.СтатусыИнтеграции.Выгружено;
		КонецЕсли;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(НовоеСообщение, СтруктураЗаписиИстории);
	Для Каждого Строка Из СтруктураЗаписиИстории.ОбъектыИнтеграции Цикл
		НоваяСтрока = НовоеСообщение.ОбъектыИнтеграции.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	НовоеСообщение.Записать();
	
КонецПроцедуры

// Функция возвращает структуру со всеми необходимыми значениями для заполнения записи истории интеграции
//
// Возвращаемое значение:
//	Строка
Функция ПолучитьСтруктуруЗаписиИстории() Экспорт
	
	СтруктураЗаписиИстории = Новый Структура;
	СтруктураЗаписиИстории.Вставить("МетодИнтеграции",			"");
	СтруктураЗаписиИстории.Вставить("ЗапросВходящий",			"");
	СтруктураЗаписиИстории.Вставить("ЗапросИсходящий",			"");
	СтруктураЗаписиИстории.Вставить("ИнтегрируемаяСистема",		Неопределено);
	СтруктураЗаписиИстории.Вставить("ОписаниеОшибки",			"");
	СтруктураЗаписиИстории.Вставить("ПротоколОбмена",			"");
	СтруктураЗаписиИстории.Вставить("ДатаНачалаИнтеграции",		ТекущаяДатаСеанса());
	СтруктураЗаписиИстории.Вставить("ДлительностьВызова",		0);
	СтруктураЗаписиИстории.Вставить("ФорматЗапросаИнтеграции",	Перечисления.ФорматыЗапросовИнтеграции.XML);
	ОбъектыИнтеграции = Новый ТаблицаЗначений;
	ОбъектыИнтеграции.Колонки.Добавить("ОбъектИнтеграции");
	ОбъектыИнтеграции.Колонки.Добавить("СозданОбновлен");
	СтруктураЗаписиИстории.Вставить("ОбъектыИнтеграции", ОбъектыИнтеграции);
	
	Возврат СтруктураЗаписиИстории;
	
КонецФункции

// Процедура добавляет сообщения в протокол обмена через указанный разделитель
// 
// Параметры:
//  СтруктураОтвета - Структура - см. ИнтеграцииСервер.ПолучитьСтруктуруЗаписиИстории
//  ТекстСообщения - Строка - Текст, который будет записан в протокол обмена
//  Разделитель - Строка - Разделитель записей
Процедура ДобавитьЗаписьВПротоколОбмена(СтруктураОтвета, ТекстСообщения, Разделитель = "") Экспорт
	
	Если ПустаяСтрока(Разделитель) Тогда
		Разделитель = ";" + Символы.ПС;
	КонецЕсли;
	
	ВыводРазделителя = ?(ПустаяСтрока(СтруктураОтвета.ПротоколОбмена), "", Разделитель);
	
	СтруктураОтвета.ПротоколОбмена = СтруктураОтвета.ПротоколОбмена + ВыводРазделителя + НСтр(ТекстСообщения);
	
КонецПроцедуры

// Функция форматирует XML запрос в строковом виде для удобного чтения
//
// Параметры:
//	XMLТекст - Строка - XML запрос в строковом виде
//	ИспользоватьОтступы - Булево - по-умолчанию Ложь
// Возвращаемое значение:
//	Строка
Функция ОтформатироватьXMLЧерезDOM(XMLТекст, ИспользоватьОтступы = Ложь) Экспорт
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(XMLТекст);
	
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку(Новый ПараметрыЗаписиXML(,, ИспользоватьОтступы, ИспользоватьОтступы));
	
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьDOM.Записать(ДокументDOM, ЗаписьXML);
	
	Возврат ЗаписьXML.Закрыть();
	
КонецФункции

// Функция возвращает структуру с настройками для интеграции
//
// Параметры:
//	НастройкаИнтеграции - СправочникСсылка.НастройкиИнтеграции - Ссылка на элемент справочника Настройки интеграции
// Возвращаемое значение:
//	Структура
Функция ПолучитьСтруктуруНастроекИнтеграции(НастройкаИнтеграции) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураНастроек = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		НастройкаИнтеграции, "ИнтегрируемаяСистема, Сервер, Порт");
	ДанныеБезопасногоХранилища = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(НастройкаИнтеграции);
	
	Для Каждого КлючИЗначение Из ДанныеБезопасногоХранилища Цикл
		СтруктураНастроек.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Функция возвращает структуру с настройками для интеграции
//
// Параметры:
//	МетодИнтеграции - СправочникСсылка.МетодыИнтеграции - Ссылка на элемент справочника Методы интеграции
// Возвращаемое значение:
//	Структура
Функция ПолучитьСтруктуруМетодаИНастроекИнтеграции(МетодИнтеграции) Экспорт
	
	СтруктураМетодаИНастроек = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(МетодИнтеграции, "НастройкаИнтеграции, Метод");
	СтруктураНастроек = ПолучитьСтруктуруНастроекИнтеграции(СтруктураМетодаИНастроек.НастройкаИнтеграции);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураМетодаИНастроек, СтруктураНастроек);
	
	Возврат СтруктураМетодаИНастроек;
	
КонецФункции

// Зашифровать base64 сервер.
// 
// Параметры:
//  ПодготовленнаяСтрока - Строка - Исходная строка, которую необходимо конвертировать в Base64
//  КодировкаТекста - Строка - Кодировка текста
// 
// Возвращаемое значение:
//  Строка - Зашифрованная строка в Base64
Функция ЗашифроватьBase64Сервер(ПодготовленнаяСтрока, КодировкаТекста = "UTF-8") Экспорт
	
	ДвоичныеДанныеСтроки = ПолучитьДвоичныеДанныеИзСтроки(ПодготовленнаяСтрока, КодировкаТекста);
	Base64Hash = ПолучитьBase64СтрокуИзДвоичныхДанных(ДвоичныеДанныеСтроки);
	
	Возврат Base64Hash; 

КонецФункции

Функция ДатаИзUnixTime(Знач Секунд) Экспорт
	
	Если Не ЗначениеЗаполнено(Секунд) Тогда
		Возврат '0001.01.01';
	ИначеЕсли ТипЗнч(Секунд) = Тип("Строка") Тогда
		Секунд = Число(Секунд);
	КонецЕсли;
	
	Дата = '1970.01.01' + Секунд;
	
	Возврат Дата;
	
КонецФункции

#Область REST

Функция ПолучитьЗапросТекстомИзСоответствияJSON(ТелоЗапросаJSON) Экспорт
	
	НастройкиСериализации = Новый НастройкиСериализацииJSON;
	НастройкиСериализации.ВариантЗаписиДаты = ВариантЗаписиДатыJSON.УниверсальнаяДата;
	НастройкиСериализации.ФорматСериализацииДаты = ФорматДатыJSON.ISO;
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, ТелоЗапросаJSON, НастройкиСериализации);
	СтрокаJSON = ЗаписьJSON.Закрыть();
	
	Возврат СтрокаJSON;
	
КонецФункции

Функция ПодготовитьТаблицуКодовОтветаHTTP() Экспорт
	
	ТаблицаКодовОтвета = Новый ТаблицаЗначений;
	ТаблицаКодовОтвета.Колонки.Добавить("КодОтвета"			, ОбщегоНазначения.ОписаниеТипаЧисло(3));
	ТаблицаКодовОтвета.Колонки.Добавить("КраткоеОписание"	, ОбщегоНазначения.ОписаниеТипаСтрока(150));
	
	// Успешные
	НоваяСтрока = ТаблицаКодовОтвета.Добавить();
	НоваяСтрока.КодОтвета		= 100;
	НоваяСтрока.КраткоеОписание	= РасшифровкаКодаСостоянияHTTP(НоваяСтрока.КодОтвета);
	
	НоваяСтрока = ТаблицаКодовОтвета.Добавить();
	НоваяСтрока.КодОтвета		= 200;
	НоваяСтрока.КраткоеОписание	= РасшифровкаКодаСостоянияHTTP(НоваяСтрока.КодОтвета);
	
	// Сообщения о перенаправлениях
	Для Инкремент = 0 По 8 Цикл
		НоваяСтрока = ТаблицаКодовОтвета.Добавить();
		
		НоваяСтрока.КодОтвета = Число("30" + Инкремент);
		НоваяСтрока.КраткоеОписание	= РасшифровкаКодаСостоянияHTTP(НоваяСтрока.КодОтвета);
	КонецЦикла;
	
	// Клиентские
	Для Инкремент = 0 По 17 Цикл
		НоваяСтрока = ТаблицаКодовОтвета.Добавить();
		
		Если Инкремент < 10 Тогда
			НоваяСтрока.КодОтвета = Число("40" + Инкремент);
		Иначе
			НоваяСтрока.КодОтвета = Число("4" + Инкремент);
		КонецЕсли;
		
		НоваяСтрока.КраткоеОписание	= РасшифровкаКодаСостоянияHTTP(НоваяСтрока.КодОтвета);
	КонецЦикла;
	
	НоваяСтрока = ТаблицаКодовОтвета.Добавить();
	НоваяСтрока.КодОтвета		= 429;
	НоваяСтрока.КраткоеОписание	= РасшифровкаКодаСостоянияHTTP(НоваяСтрока.КодОтвета);
	
	// Серверные
	Для Инкремент = 0 По 11 Цикл
		НоваяСтрока = ТаблицаКодовОтвета.Добавить();
		
		Если Инкремент < 10 Тогда
			НоваяСтрока.КодОтвета = Число("50" + Инкремент);
		Иначе
			НоваяСтрока.КодОтвета = Число("5" + Инкремент);
		КонецЕсли;
		
		НоваяСтрока.КраткоеОписание	= РасшифровкаКодаСостоянияHTTP(НоваяСтрока.КодОтвета);
	КонецЦикла;
	
	Возврат ТаблицаКодовОтвета;
	
КонецФункции

Функция РасшифровкаКодаСостоянияHTTP(КодСостояния) Экспорт
	
	Если 100 <= КодСостояния И КодСостояния <= 299 Тогда
		Расшифровка = НСтр("ru = 'Успешно.'");
	ИначеЕсли КодСостояния = 300 Тогда // Multiple Choice
		Расшифровка = НСтр("ru = 'Запрос имеет более чем один из возможных ответов.'");
	ИначеЕсли КодСостояния = 301 Тогда // Moved Permanently
		Расшифровка = НСтр("ru = 'URI запрашиваемого ресурса был изменён.'");
	ИначеЕсли КодСостояния = 302 Тогда // Found
		Расшифровка = НСтр("ru = 'Запрошенный ресурс временно изменён.'");
	ИначеЕсли КодСостояния = 303 Тогда // See Other
		Расшифровка = НСтр("ru = 'Попробуйте получить запрашиваемый ресурс в другой URI с запросом GET.'");
	ИначеЕсли КодСостояния = 304 Тогда // Not Modified
		Расшифровка = НСтр("ru = 'Нет необходимости повторно передавать запрошенные ресурсы.'");
	ИначеЕсли КодСостояния = 305 Тогда // Use Proxy
		Расшифровка = НСтр("ru = 'Запрошенный ресурс должен быть доступен через прокси.'");
	ИначеЕсли КодСостояния = 306 Тогда // Switch Proxy
		Расшифровка = НСтр("ru = 'Последующие запросы должны использовать указанный прокси.'");
	ИначеЕсли КодСостояния = 307 Тогда // Temporary Redirect
		Расшифровка = НСтр("ru = 'Запрошенный ресурс временно перенаправлен на другой URL-адрес с тем же методом, который использовал предыдущий запрос.'");
	ИначеЕсли КодСостояния = 308 Тогда // Permanent Redirect
		Расшифровка = НСтр("ru = 'Запрошенный ресурс теперь постоянно находится в другом URI.'");
	ИначеЕсли КодСостояния = 400 Тогда // Bad Request
		Расшифровка = НСтр("ru = 'Запрос не может быть исполнен.'");
	ИначеЕсли КодСостояния = 401 Тогда // Unauthorized
		Расшифровка = НСтр("ru = 'Попытка авторизации на сервере была отклонена.'");
	ИначеЕсли КодСостояния = 402 Тогда // Payment Required
		Расшифровка = НСтр("ru = 'Требуется оплата.'");
	ИначеЕсли КодСостояния = 403 Тогда // Forbidden
		Расшифровка = НСтр("ru = 'К запрашиваемому ресурсу нет доступа.'");
	ИначеЕсли КодСостояния = 404 Тогда // Not Found
		Расшифровка = НСтр("ru = 'Запрашиваемый ресурс не существует на сервере.'");
	ИначеЕсли КодСостояния = 405 Тогда // Method Not Allowed
		Расшифровка = НСтр("ru = 'Метод запроса не поддерживается сервером.'");
	ИначеЕсли КодСостояния = 406 Тогда // Not Acceptable
		Расшифровка = НСтр("ru = 'Запрошенный формат данных не поддерживается сервером.'");
	ИначеЕсли КодСостояния = 407 Тогда // Proxy Authentication Required
		Расшифровка = НСтр("ru = 'Ошибка аутентификации на прокси-сервере'");
	ИначеЕсли КодСостояния = 408 Тогда // Request Timeout
		Расшифровка = НСтр("ru = 'Время ожидания сервером передачи от клиента истекло.'");
	ИначеЕсли КодСостояния = 409 Тогда // Conflict
		Расшифровка = НСтр("ru = 'Запрос не может быть выполнен из-за конфликтного обращения к ресурсу.'");
	ИначеЕсли КодСостояния = 410 Тогда // Gone
		Расшифровка = НСтр("ru = 'Ресурс на сервере был перемещен.'");
	ИначеЕсли КодСостояния = 411 Тогда // Length Required
		Расшифровка = НСтр("ru = 'Сервер требует указание ""Content-length."" в заголовке запроса.'");
	ИначеЕсли КодСостояния = 412 Тогда // Precondition Failed
		Расшифровка = НСтр("ru = 'Запрос не применим к ресурсу'");
	ИначеЕсли КодСостояния = 413 Тогда // Request Entity Too Large
		Расшифровка = НСтр("ru = 'Сервер отказывается обработать, слишком большой объем передаваемых данных.'");
	ИначеЕсли КодСостояния = 414 Тогда // Request-URL Too Long
		Расшифровка = НСтр("ru = 'Сервер отказывается обработать, слишком длинный URL.'");
	ИначеЕсли КодСостояния = 415 Тогда // Unsupported Media-Type
		Расшифровка = НСтр("ru = 'Сервер заметил, что часть запроса была сделана в неподдерживаемом формат'");
	ИначеЕсли КодСостояния = 416 Тогда // Requested Range Not Satisfiable
		Расшифровка = НСтр("ru = 'Часть запрашиваемого ресурса не может быть предоставлена'");
	ИначеЕсли КодСостояния = 417 Тогда // Expectation Failed
		Расшифровка = НСтр("ru = 'Сервер не может предоставить ответ на указанный запрос.'");
	ИначеЕсли КодСостояния = 429 Тогда // Too Many Requests
		Расшифровка = НСтр("ru = 'Слишком много запросов за короткое время.'");
	ИначеЕсли КодСостояния = 500 Тогда // Internal Server Error
		Расшифровка = НСтр("ru = 'Внутренняя ошибка сервера.'");
	ИначеЕсли КодСостояния = 501 Тогда // Not Implemented
		Расшифровка = НСтр("ru = 'Сервер не поддерживает метод запроса.'");
	ИначеЕсли КодСостояния = 502 Тогда // Bad Gateway
		Расшифровка = НСтр("ru = 'Сервер, выступая в роли шлюза или прокси-сервера, 
		                         |получил недействительное ответное сообщение от вышестоящего сервера.'");
	ИначеЕсли КодСостояния = 503 Тогда // Server Unavailable
		Расшифровка = НСтр("ru = 'Сервер временно не доступен.'");
	ИначеЕсли КодСостояния = 504 Тогда // Gateway Timeout
		Расшифровка = НСтр("ru = 'Сервер в роли шлюза или прокси-сервера 
		                         |не дождался ответа от вышестоящего сервера для завершения текущего запроса.'");
	ИначеЕсли КодСостояния = 505 Тогда // HTTP Version Not Supported
		Расшифровка = НСтр("ru = 'Сервер не поддерживает указанную в запросе версию протокола HTTP'");
	ИначеЕсли КодСостояния = 506 Тогда // Variant Also Negotiates
		Расшифровка = НСтр("ru = 'Сервер настроен некорректно, и не способен обработать запрос.'");
	ИначеЕсли КодСостояния = 507 Тогда // Insufficient Storage
		Расшифровка = НСтр("ru = 'На сервере недостаточно места для выполнения запроса.'");
	ИначеЕсли КодСостояния = 509 Тогда // Bandwidth Limit Exceeded
		Расшифровка = НСтр("ru = 'Сервер превысил отведенное ограничение на потребление трафика.'");
	ИначеЕсли КодСостояния = 510 Тогда // Not Extended
		Расшифровка = НСтр("ru = 'Сервер требует больше информации о совершаемом запросе.'");
	ИначеЕсли КодСостояния = 511 Тогда // Network Authentication Required
		Расшифровка = НСтр("ru = 'Требуется авторизация на сервере.'");
	Иначе 
		Расшифровка = НСтр("ru = '<Неизвестный код состояния>.'");
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '[%1] %2'"), 
		КодСостояния, 
		Расшифровка);
	
КонецФункции

#КонецОбласти // REST

// Получить таблицу соответствий пользователей систем.
// 
// Параметры:
//  МассивИдентификаторовПользователей	 - Массив - Массив идентификаторов пользователей
//  МассивИменПользователей				 - Массив - Массив имен пользователей
//  НастройкиИнтеграции					 - СправочникСсылка.НастройкиИнтеграции - Настройки интеграции
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Получить таблицу соответствий пользователей систем
Функция ПолучитьТаблицуСоответствийПользователейСистем(
	МассивИдентификаторовПользователей, МассивИменПользователей, НастройкиИнтеграции) Экспорт
	
	Возврат РегистрыСведений.СоответствияПользователейСистем.ПолучитьТаблицуСоответствийПользователейСистем(
		МассивИдентификаторовПользователей, МассивИменПользователей, НастройкиИнтеграции);
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

// Процедура обрабатывает запросы в структуре записи истории
Процедура ДополнительноОбработатьЗапросыИнтеграцииПередЗаписьюВИсторию(СтруктураЗаписиИстории)
	
	Если НЕ ПустаяСтрока(СтруктураЗаписиИстории.ЗапросИсходящий) И СтрНайти(СтруктураЗаписиИстории.ЗапросИсходящий, "xml") <> 0 Тогда
		
		ОчиститьДлинныеАтрибутыСообщенияXML(СтруктураЗаписиИстории.ЗапросИсходящий);
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(СтруктураЗаписиИстории.ЗапросВходящий) И СтрНайти(СтруктураЗаписиИстории.ЗапросВходящий, "xml") <> 0 Тогда
		
		ОчиститьДлинныеАтрибутыСообщенияXML(СтруктураЗаписиИстории.ЗапросВходящий);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура очищает XML строку от длинных записей (например base64 строк)
Процедура ОчиститьДлинныеАтрибутыСообщенияXML(XMLСтрока)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(XMLСтрока);
	
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	
	ТребуетсяПерезаписатьXML = Ложь;
	
	//Перебрать все узлы
	ИтераторДерева = Новый ОбходДереваDOM(ДокументDOM);
	Пока ИтераторДерева.СледующийУзел() <> Неопределено Цикл
		Если ТипЗнч(ИтераторДерева.ТекущийУзел) = Тип("ЭлементDOM") Тогда
			Если СтрДлина(ИтераторДерева.ТекущийУзел.ТекстовоеСодержимое) > 1000 Тогда
				ИтераторДерева.ТекущийУзел.ТекстовоеСодержимое = "X";
				ТребуетсяПерезаписатьXML = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ТребуетсяПерезаписатьXML Тогда
		
		ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.УстановитьСтроку(Новый ПараметрыЗаписиXML(, , Истина, Истина));
		
		ЗаписьDOM = Новый ЗаписьDOM;
		ЗаписьDOM.Записать(ДокументDOM, ЗаписьXML);
		
		XMLСтрока = ЗаписьXML.Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции