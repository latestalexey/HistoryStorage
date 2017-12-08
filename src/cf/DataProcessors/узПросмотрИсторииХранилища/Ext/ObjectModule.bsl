﻿Перем мТЗHistory;
Перем мТЗUsers;
Перем мТЗVersions;
Перем мТЗObjects;
Перем мТЗИменаКлассов;
Перем мИмяКлассаОбъекта_Конфигурация;

Функция ПолучитьТЗИсторияХранилища(ДопПараметры) Экспорт
	
	ЗагрузитьИсторию();
	
	ТЗИсторияХранилищаСтруктура = ДопПараметры.ТЗИсторияХранилищаСтруктура;
	ТЗИзмененныеОбъектыСтруктура = ДопПараметры.ТЗИзмененныеОбъектыСтруктура;
	
	ТЗИсторияХранилища = ТЗИсторияХранилищаСтруктура.СкопироватьКолонки();
	
	Для каждого СтрокаИсторияХранилища из ИсторияХранилища цикл
		пВерсия = СтрокаИсторияХранилища.Версия;
		
		СтрокаТЗИсторияХранилища = ТЗИсторияХранилища.Добавить();
		СтрокаТЗИсторияХранилища.Версия = пВерсия;
		СтрокаТЗИсторияХранилища.ДатаВерсии = СтрокаИсторияХранилища.ДатаВерсии;
		СтрокаТЗИсторияХранилища.ПользовательХранилища = СтрокаИсторияХранилища.ПользовательХранилища;
		СтрокаТЗИсторияХранилища.Комментарий = СтрокаИсторияХранилища.Комментарий;
		
		ПараметрыОтбора=Новый Структура();
		ПараметрыОтбора.Вставить("Версия",пВерсия);
		НайденныеСтрокиИзмененныеОбъекты = ИзмененныеОбъекты.НайтиСтроки(ПараметрыОтбора);
		ВсегоНайденныеСтроки = НайденныеСтрокиИзмененныеОбъекты.Количество();
		ТекстОшибки = "";
		Если ВсегоНайденныеСтроки = 0 Тогда 
			ТекстОшибки = "Ошибка! Не найдена строка";
		Конецесли;
		
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ТекстОшибки = ТекстОшибки  
				+" в ""ИзмененныеОбъекты"" для ";
			Для каждого ЭлементОтбора из ПараметрыОтбора цикл
				ТекстОшибки = ТекстОшибки  
					+" "+ ЭлементОтбора.Ключ + " = "+ЭлементОтбора.Значение;				
			Конеццикла;
			ВызватьИсключение ТекстОшибки;	
		Конецесли;
		
		ТЗИзмененныеОбъекты = ТЗИзмененныеОбъектыСтруктура.СкопироватьКолонки();
		Для каждого СтрокаИзмененныеОбъекты из НайденныеСтрокиИзмененныеОбъекты цикл
			СтрокаТЗИзмененныеОбъекты = ТЗИзмененныеОбъекты.Добавить();
			СтрокаТЗИзмененныеОбъекты.ВидИзменения = СтрокаИзмененныеОбъекты.ВидИзменения; 
			СтрокаТЗИзмененныеОбъекты.ТекстИдентификатораОбъектаМетаданных = СтрокаИзмененныеОбъекты.ТекстИдентификатораОбъектаМетаданных;
		Конеццикла;
		СтрокаТЗИсторияХранилища.ТЗИзмененныеОбъекты = ТЗИзмененныеОбъекты;
	Конеццикла;
	
	Возврат ТЗИсторияХранилища;
КонецФункции

Процедура ЗагрузитьИсторию() Экспорт
	ВремяНачала=ТекущаяДата();
	
	мТЗHistory = Неопределено;
	мТЗUsers = Неопределено;
	мТЗVersions = Неопределено;
	мТЗObjects = Неопределено;
	
	ЗагрузитьДанныеВТЗИзХранилища();
	
	ВывестиСообщение("Заполнение ТЧ Обработки");
	мТЗИменаКлассов = ПолучитьТЗИменаКлассов();
	
	Если ВывестиСлужебнуюТаблицу Тогда
		СоединитьТаблицыТЗHistoryИТЗOBJECTS(мТЗHistory,мТЗObjects);		
	Иначе
		ЗаполнитьТЧОбработки();
	Конецесли;
	
	мТЗHistory = Неопределено;
	мТЗUsers = Неопределено;
	мТЗVersions = Неопределено;
	мТЗObjects = Неопределено;
	мТЗИменаКлассов = Неопределено;
	
	ВремяКонца=ТекущаяДата();
	
	ВывестиСообщение("------------------------------------------------------------------");
	ВывестиСообщение("ВремяНачала -"+ВремяНачала);
	ВывестиСообщение("ВремяКонца  -"+ВремяКонца);
	ВывестиСообщение("Общее время выполнения - "+ОКР(((ВремяКонца-ВремяНачала)/60),2) +" мин.");
	ВывестиСообщение("------------------------------------------------------------------");		
КонецПроцедуры 

Процедура ЗагрузитьДанныеВТЗИзХранилища()
	
	РезультатВыгрузки = ВыгрузитьТаблицыХранилищаВФайлы();
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ИмяПространстваИмен","http://localhost/узHISTORYXDTO");
	ДопПараметры.Вставить("ИмяТаблицы","HISTORY");
	ДопПараметры.Вставить("ИмяФайлаДляЗагрузки",РезультатВыгрузки.ИмяФайлаHISTORY);
	
	мТЗHistory = ПолучитьТЗИзФайла(ДопПараметры);
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ИмяПространстваИмен","http://localhost/узUSERSXDTO");
	ДопПараметры.Вставить("ИмяТаблицы","USERS");
	ДопПараметры.Вставить("ИмяФайлаДляЗагрузки",РезультатВыгрузки.ИмяФайлаUSERS);
	
	мТЗUsers = ПолучитьТЗИзФайла(ДопПараметры);	
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ИмяПространстваИмен","http://localhost/узVERSIONSXDTO");
	ДопПараметры.Вставить("ИмяТаблицы","VERSIONS");
	ДопПараметры.Вставить("ИмяФайлаДляЗагрузки",РезультатВыгрузки.ИмяФайлаVERSIONS);
	
	мТЗVersions = ПолучитьТЗИзФайла(ДопПараметры);

	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ИмяПространстваИмен","http://localhost/узOBJECTSXDTO");
	ДопПараметры.Вставить("ИмяТаблицы","OBJECTS");
	ДопПараметры.Вставить("ИмяФайлаДляЗагрузки",РезультатВыгрузки.ИмяФайлаOBJECTS);
	
	мТЗObjects = ПолучитьТЗИзФайла(ДопПараметры);	
	
	УдалитьВременныеФайлы(РезультатВыгрузки);
КонецПроцедуры 

Функция ЗаполнитьТЧОбработки() 
	ИсторияХранилища.Очистить();
	ИзмененныеОбъекты.Очистить();
	
	пВерсияПо = ВерсияПо;
	Если пВерсияПо = 0 Тогда
		пВерсияПо = 9999999999;	
	Конецесли;
	
	Для каждого СтрокамТЗVersions из мТЗVersions цикл
		пVERNUM = СтрокамТЗVersions.VERNUM;
		Если ВерсияС <= пVERNUM
			И пVERNUM <= пВерсияПо Тогда
		Иначе
			Продолжить;
		Конецесли;
		
		СтрокаИсторияХранилища = ИсторияХранилища.Добавить();
		СтрокаИсторияХранилища.Версия = пVERNUM;
		СтрокаИсторияХранилища.ДатаВерсии = СтрокамТЗVersions.VERDATE;
		пUSERID = СтрокамТЗVersions.USERID;
		СтрокаИсторияХранилища.ПользовательХранилища = ПолучитьПользователяХранилища(пUSERID);
		СтрокаИсторияХранилища.Комментарий = СтрокамТЗVersions.COMMENT;
		СтрокаИсторияХранилища.ВерсияКонфигурации = СтрокамТЗVersions.CODE;
		
		ПараметрыОтбора=Новый Структура();
		ПараметрыОтбора.Вставить("VERNUM",пVERNUM);
		НайденныеСтрокимТЗHistory = мТЗHistory.НайтиСтроки(ПараметрыОтбора);
		ВсегоНайденныеСтроки = НайденныеСтрокимТЗHistory.Количество();
		ТекстОшибки = "";
		Если ВсегоНайденныеСтроки = 0 тогда
			ТекстОшибки = "Ошибка! Не найдена строка";
			ТекстОшибки = ТекстОшибки  
				+" в ""мТЗHistory"" для ";
			Для каждого ЭлементОтбора из ПараметрыОтбора цикл
				ТекстОшибки = ТекстОшибки  
					+" "+ ЭлементОтбора.Ключ + " = "+ЭлементОтбора.Значение;				
			Конеццикла;
			ВызватьИсключение ТекстОшибки;				
		Конецесли;
		
		Для каждого СтрокамТЗHistory из НайденныеСтрокимТЗHistory цикл
			ПолноеИмяМетаданных = "";
			ПолноеИмяМетаданных = ПолучитьПолноеИмяМетаданных(ПолноеИмяМетаданных,СтрокамТЗHistory);;			
			
			СтрокаИзмененныеОбъекты = ИзмененныеОбъекты.Добавить();
			СтрокаИзмененныеОбъекты.Версия = пVERNUM;
			СтрокаИзмененныеОбъекты.ВидИзменения = ПолучитьВидИзменения(СтрокамТЗHistory);						
			СтрокаИзмененныеОбъекты.ТекстИдентификатораОбъектаМетаданных = ПолноеИмяМетаданных;
		Конеццикла;
		
	Конеццикла;
	ИсторияХранилища.Сортировать("Версия");
КонецФункции 

Функция ПолучитьПолноеИмяМетаданных(ПолноеИмяМетаданных,СтрокамТЗHistory) 
	ИмяОбъекта = СтрокамТЗHistory.OBJNAME;	
	ИмяКлассаОбъекта = ПолучитьИмяКлассаОбъекта(СтрокамТЗHistory.OBJID);	
	
	Если ЗначениеЗаполнено(ПолноеИмяМетаданных) Тогда
		Если ИмяКлассаОбъекта <> мИмяКлассаОбъекта_Конфигурация Тогда
			ПолноеИмяМетаданных = ИмяКлассаОбъекта + "."+ИмяОбъекта +"."+ ПолноеИмяМетаданных;	
		Конецесли;
	Иначе
		Если ИмяКлассаОбъекта = мИмяКлассаОбъекта_Конфигурация Тогда
			ПолноеИмяМетаданных = ИмяОбъекта;
		Иначе
			ПолноеИмяМетаданных = ИмяКлассаОбъекта + "."+ИмяОбъекта;	
		Конецесли;
	Конецесли;
	
	СтрокаРодителя = ПолучитьСтрокуРодителя(СтрокамТЗHistory.PARENTID);
	Если ЗначениеЗаполнено(СтрокаРодителя) Тогда
		ПолучитьПолноеИмяМетаданных(ПолноеИмяМетаданных,СтрокаРодителя)	
	Конецесли;
	
	Возврат ПолноеИмяМетаданных;
КонецФункции 

Функция ПолучитьСтрокуРодителя(РодительOBJID) 
	Перем СтрокаРодителя;
	
	ПараметрыОтбора=Новый Структура();
	ПараметрыОтбора.Вставить("OBJID",РодительOBJID);
	НайденныеСтроки = мТЗHistory.НайтиСтроки(ПараметрыОтбора);
	ВсегоНайденныеСтроки = НайденныеСтроки.Количество();
	ТекстОшибки = "";
	Если ВсегоНайденныеСтроки >= 1 Тогда
		СтрокаРодителя = НайденныеСтроки[0];	
	Конецесли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ТекстОшибки = ТекстОшибки  
			+" в ""мТЗHistory"" для ";
		Для каждого ЭлементОтбора из ПараметрыОтбора цикл
			ТекстОшибки = ТекстОшибки  
				+" "+ ЭлементОтбора.Ключ + " = "+ЭлементОтбора.Значение;				
		Конеццикла;
		ВызватьИсключение ТекстОшибки;	
	Конецесли;
	
	Возврат СтрокаРодителя;
КонецФункции 

Функция ПолучитьИмяКлассаОбъекта(ЗНАЧ OBJID) 
	Перем CLASSID;
	Перем ИмяКласса;
	
	ПараметрыОтбора=Новый Структура();
	ПараметрыОтбора.Вставить("OBJID",OBJID);
	НайденныеСтрокимТЗObjects = мТЗObjects.НайтиСтроки(ПараметрыОтбора);
	ВсегоНайденныеСтроки = НайденныеСтрокимТЗObjects.Количество();
	ТекстОшибки = "";
	Если ВсегоНайденныеСтроки = 1 тогда
		СтрокамТЗObjects = НайденныеСтрокимТЗObjects[0];	
		CLASSID = СтрокамТЗObjects.CLASSID;
	ИначеЕсли ВсегоНайденныеСтроки > 1 Тогда
		ТекстОшибки = "Ошибка! Найдено более 1 строки";
	Иначе
		ТекстОшибки = "Ошибка! Не найдена строка";
	Конецесли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ТекстОшибки = ТекстОшибки  
			+" в ""мТЗObjects"" для ";
		Для каждого ЭлементОтбора из ПараметрыОтбора цикл
			ТекстОшибки = ТекстОшибки  
				+" "+ ЭлементОтбора.Ключ + " = "+ЭлементОтбора.Значение;				
		Конеццикла;
		ВызватьИсключение ТекстОшибки;	
	Конецесли;
	
	
	ПараметрыОтбора=Новый Структура();
	ПараметрыОтбора.Вставить("CLASSID",CLASSID);
	НайденныеСтрокимТЗИменаКлассов = мТЗИменаКлассов.НайтиСтроки(ПараметрыОтбора);
	ВсегоНайденныеСтроки = НайденныеСтрокимТЗИменаКлассов.Количество();
	ТекстОшибки = "";
	Если ВсегоНайденныеСтроки = 1 тогда
		СтрокамТЗИменаКлассов = НайденныеСтрокимТЗИменаКлассов[0];	
		ИмяКласса = СтрокамТЗИменаКлассов.ИмяКласса; 
	ИначеЕсли ВсегоНайденныеСтроки > 1 Тогда
		ТекстОшибки = "Ошибка! Найдено более 1 строки";
	Иначе
		ТекстОшибки = "Ошибка! Не найдена строка";
	Конецесли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ТекстОшибки = ТекстОшибки  
			+" в ""мТЗИменаКлассов"" для ";
		Для каждого ЭлементОтбора из ПараметрыОтбора цикл
			ТекстОшибки = ТекстОшибки  
				+" "+ ЭлементОтбора.Ключ + " = "+ЭлементОтбора.Значение;				
		Конеццикла;
		Сообщить(ТекстОшибки);	
		ИмяКласса = "";
	Конецесли;
	
	Возврат ИмяКласса;	
КонецФункции 

Функция ПолучитьВидИзменения(СтрокамТЗHistory) 
	
	пВидИзменения = ПредопределенноеЗначение("Перечисление.узВидыИзменений.Изменен");
	
	Если СтрокамТЗHistory.SELFVERNUM = 1 Тогда
		пВидИзменения = ПредопределенноеЗначение("Перечисление.узВидыИзменений.Добавлен");
	Конецесли;
	
	Если СтрокамТЗHistory.REMOVED  Тогда
		пВидИзменения = ПредопределенноеЗначение("Перечисление.узВидыИзменений.Удален");
	Конецесли;	
	
	Возврат пВидИзменения;
КонецФункции 

Функция ПолучитьПользователяХранилища(пUSERID) 
	Перем пПользовательХранилища;
	
	ПараметрыОтбора=Новый Структура();
	ПараметрыОтбора.Вставить("USERID",пUSERID);
	НайденныеСтроки = мТЗUsers.НайтиСтроки(ПараметрыОтбора);
	ВсегоНайденныеСтроки = НайденныеСтроки.Количество();
	ТекстОшибки = "";
	Если ВсегоНайденныеСтроки = 1 тогда
		СтрокамТЗUsers = НайденныеСтроки[0];
		пПользовательХранилища = СтрокамТЗUsers.Name;
	ИначеЕсли ВсегоНайденныеСтроки > 1 Тогда
		ТекстОшибки = "Ошибка! Найдено более 1 строки";
	Иначе
		ТекстОшибки = "Ошибка! Не найдена строка";
	Конецесли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ТекстОшибки = ТекстОшибки  
			+" в ""мТЗUsers"" для ";
		Для каждого ЭлементОтбора из ПараметрыОтбора цикл
			ТекстОшибки = ТекстОшибки  
				+" "+ ЭлементОтбора.Ключ + " = "+ЭлементОтбора.Значение;				
		Конеццикла;
		ВызватьИсключение ТекстОшибки;	
	Конецесли;
	
	Возврат пПользовательХранилища;
КонецФункции 

Функция ПолучитьТЗИменаКлассов() 
	Массив=Новый Массив;
	Массив.Добавить(Тип("Строка"));
	ТипСтрока_150 = Новый ОписаниеТипов(Массив, , ,Новый КвалификаторыСтроки(150));		
	
	ТЗИменаКлассов = Новый ТаблицаЗначений;
	ТЗИменаКлассов.Колонки.Добавить("CLASSID",ПолучитьТипСтрока36());
	ТЗИменаКлассов.Колонки.Добавить("ИмяКласса",ТипСтрока_150);
	
	Макет = ПолучитьМакет("ИменаКлассов");

	Для НомерСтроки = 2 По Макет.ВысотаТаблицы Цикл
		CLASSID = СокрЛП(Макет.Область(НомерСтроки,1).Текст);
		ИмяКласса = СокрЛП(Макет.Область(НомерСтроки,2).Текст);
		
		СтрокаТЗИменаКлассов = ТЗИменаКлассов.Добавить();
		СтрокаТЗИменаКлассов.CLASSID = CLASSID;
		СтрокаТЗИменаКлассов.ИмяКласса = ИмяКласса;
		
	КонецЦикла;
	
	Возврат ТЗИменаКлассов;	
КонецФункции 

Процедура СоединитьТаблицыТЗHistoryИТЗOBJECTS(ТЗHistory,ТЗOBJECTS)
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТЗHISTORY.OBJID КАК OBJID,
	|	ТЗHISTORY.OBJNAME КАК OBJNAME,
	|	ТЗHISTORY.PARENTID КАК PARENTID,
	|	ТЗHISTORY.REMOVED КАК REMOVED,
	|	ТЗHISTORY.SELFVERNUM КАК SELFVERNUM,
	|	ТЗHISTORY.VERNUM КАК VERNUM
	|ПОМЕСТИТЬ ТЗHISTORY
	|ИЗ
	|	&ТЗHISTORY КАК ТЗHISTORY
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЗOBJECTS.OBJID,
	|	ТЗOBJECTS.CLASSID
	|ПОМЕСТИТЬ ТЗOBJECTS
	|ИЗ
	|	&ТЗOBJECTS КАК ТЗOBJECTS
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЗHISTORY.OBJID КАК OBJID,
	|	ТЗHISTORY.OBJNAME КАК OBJNAME,
	|	ТЗHISTORY.PARENTID КАК PARENTID,
	|	ТЗHISTORY.REMOVED КАК REMOVED,
	|	ТЗHISTORY.SELFVERNUM КАК SELFVERNUM,
	|	ТЗHISTORY.VERNUM КАК VERNUM,
	|	ТЗOBJECTS.OBJID КАК OBJID_ТЗOBJECTS,
	|	ТЗOBJECTS.CLASSID КАК CLASSID
	|ИЗ
	|	ТЗHISTORY КАК ТЗHISTORY
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТЗOBJECTS КАК ТЗOBJECTS
	|		ПО ТЗHISTORY.OBJID = ТЗOBJECTS.OBJID
	|");

	Запрос.УстановитьПараметр("ТЗHISTORY", ТЗHistory);
	Запрос.УстановитьПараметр("ТЗOBJECTS", ТЗOBJECTS);

	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗРезультат = РезультатЗапроса.Выгрузить();
	
	ТабДок = Новый ТабличныйДокумент;
    
    Построитель = Новый ПостроительОтчета();

    Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТЗРезультат);
    Построитель.ВыводитьЗаголовокОтчета = Ложь;
    Построитель.Вывести(ТабДок);

    ИмяФайла = "" + КаталогВременныхФайлов() + "\History.xlsx";
    
    ТабДок.Записать(ИмяФайла,ТипФайлаТабличногоДокумента.XLSX);	
	Сообщить("Сохранена служебная таблица: " + ИмяФайла);
		
КонецПроцедуры 

Функция ПолучитьТЗИзФайла(ДопПараметры) 
	Перем ТЗИзФайла;
	
	ИмяФайлаДляЗагрузки = ДопПараметры.ИмяФайлаДляЗагрузки; 
	ИмяПространстваИмен = ДопПараметры.ИмяПространстваИмен;
	ИмяПакетаXDTO = "Table";
	ИмяТаблицы = ДопПараметры.ИмяТаблицы;
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяФайлаДляЗагрузки ,КодировкаТекста.UTF16);               // XML документ не имеет атрибута
	СтрокаXML = ЧтениеТекста.Прочитать();                                                        // xmlns - URIПространстваИмен
	//СтрокаXML = СтрЗаменить(СтрокаXML,"<Records","<Records xmlns="""+ИмяПространстваИмен+""" ");	
	//СтрокаXML = СтрЗаменить(СтрокаXML,"<Table Name=""HISTORY""","<Table Name=""HISTORY"" xmlns="""+ИмяПространстваИмен+""" ");
	СтрокаXML = СтрЗаменить(СтрокаXML,"<Table Name="""+ИмяТаблицы+"""","<Table Name="""+ИмяТаблицы+""" xmlns="""+ИмяПространстваИмен+""" ");
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	ПакетХранилищаXDTO = ФабрикаXDTO.Тип(ИмяПространстваИмен,ИмяПакетаXDTO);
	Если ПакетХранилищаXDTO = Неопределено Тогда
		ВызватьИсключение "Ошибка! не удалось определить Тип пакета XDTO";
	Конецесли;
	ФайлХранилища = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,ПакетХранилищаXDTO);

	ТЗИзФайла = ПолучитьОписаниеТЗИзФайла(ИмяТаблицы);
	#Если Тромбон тогда
		ТЗИзФайла = Новый ТаблицаЗначений;
	#Конецесли
	
	Для каждого СтрокаRecord из ФайлХранилища.Records.Record цикл
		СтрокаТЗИзФайла = ТЗИзФайла.Добавить();
		Для каждого Колонка из ТЗИзФайла.Колонки цикл
			ИмяКолонки = Колонка.Имя;
			ЗначениеИзФайла = СтрокаRecord[ИмяКолонки];
			
			СтрокаТЗИзФайла[ИмяКолонки] = ЗначениеИзФайла;
		Конеццикла;
	КонецЦикла;
	
	ФайлХранилища = Неопределено;
	Возврат ТЗИзФайла;	
КонецФункции 

Функция ПолучитьТипСтрока36() 
	Массив=Новый Массив;
	Массив.Добавить(Тип("Строка"));
	ТипСтрока_36 = Новый ОписаниеТипов(Массив, , ,Новый КвалификаторыСтроки(36));	
	
	Возврат ТипСтрока_36;
КонецФункции 

Функция ПолучитьОписаниеТЗИзФайла(ИмяТаблицы) 
	Перем ТЗИзФайла;
	
	ТипСтрока_36 = ПолучитьТипСтрока36();
	
	Если ИмяТаблицы = "HISTORY" Тогда
		ТЗИзФайла = Новый ТаблицаЗначений();
		ТЗИзФайла.Колонки.Добавить("OBJID",ТипСтрока_36);
		ТЗИзФайла.Колонки.Добавить("VERNUM",Новый ОписаниеТипов("Число"));
		ТЗИзФайла.Колонки.Добавить("SELFVERNUM",Новый ОписаниеТипов("Число"));
		ТЗИзФайла.Колонки.Добавить("OBJVERID",ТипСтрока_36);
		ТЗИзФайла.Колонки.Добавить("PARENTID",ТипСтрока_36);	
		ТЗИзФайла.Колонки.Добавить("OWNERID",ТипСтрока_36);
		ТЗИзФайла.Колонки.Добавить("OBJNAME",Новый ОписаниеТипов("Строка"));
		ТЗИзФайла.Колонки.Добавить("OBJPOS",Новый ОписаниеТипов("Число"));
		ТЗИзФайла.Колонки.Добавить("REMOVED",Новый ОписаниеТипов("Булево"));
		
		ТЗИзФайла.Индексы.Добавить("VERNUM,OBJID,PARENTID");
		
	ИначеЕсли ИмяТаблицы = "USERS" Тогда
		ТЗИзФайла = Новый ТаблицаЗначений();
		ТЗИзФайла.Колонки.Добавить("USERID",ТипСтрока_36);
		ТЗИзФайла.Колонки.Добавить("NAME",Новый ОписаниеТипов("Строка"));
		
	ИначеЕсли ИмяТаблицы = "VERSIONS" Тогда
		
		ТЗИзФайла = Новый ТаблицаЗначений();
		ТЗИзФайла.Колонки.Добавить("VERNUM",Новый ОписаниеТипов("Число"));
		ТЗИзФайла.Колонки.Добавить("USERID",ТипСтрока_36);
		ТЗИзФайла.Колонки.Добавить("VERDATE",Новый ОписаниеТипов("Дата"));
		ТЗИзФайла.Колонки.Добавить("COMMENT",Новый ОписаниеТипов("Строка"));
		ТЗИзФайла.Колонки.Добавить("CODE",Новый ОписаниеТипов("Строка"));
		
	ИначеЕсли ИмяТаблицы = "OBJECTS" Тогда
		
		ТЗИзФайла = Новый ТаблицаЗначений();
		ТЗИзФайла.Колонки.Добавить("OBJID",ТипСтрока_36);
		ТЗИзФайла.Колонки.Добавить("CLASSID",ТипСтрока_36);
		//ТЗИзФайла.Колонки.Добавить("SELFVERNUM",Новый ОписаниеТипов("Число"));
	Иначе
		ВызватьИсключение "Ошибка! Нет алгоритма описание ТЗИзФайла для ["+ИмяТаблицы+"]";
	Конецесли;
	
	Возврат ТЗИзФайла;
КонецФункции 

Функция ВыгрузитьТаблицыХранилищаВФайлы()
	ИмяФайлаХранилища = КаталогХранилища + "\1cv8ddb.1CD";
	
	ФайлХранилища = Новый Файл(ИмяФайлаХранилища);
	Если НЕ ФайлХранилища.Существует() Тогда
		ТекстОшибки = "Ошибка! Не удалось найти файл ["+ИмяФайлаХранилища+"]";
		ВывестиСообщение(ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ФайлХранилища = Неопределено; 
	
	пКаталогВременныхФайлов = КаталогВременныхФайлов();
	мИмяФайлаДляTool_1CD = пКаталогВременныхФайлов + "cTool_1CD.exe";	
	
	Макет_cTool_1CD = ПолучитьМакет("cTool_1CD");
	Макет_cTool_1CD.Записать(мИмяФайлаДляTool_1CD);
	
	ВывестиСообщение("Создали файл: " + мИмяФайлаДляTool_1CD);
	
	ТекстКоманды = СоздатьКоманду(мИмяФайлаДляTool_1CD);
	
	ИмяФайлаХранилища = Экранировать(ИмяФайлаХранилища);
	
	КаталогВыгрузкиФайлов = Лев(пКаталогВременныхФайлов,СтрДлина(пКаталогВременныхФайлов)-1);
	
	ДобавитьВКомандуКлючЗначение(ТекстКоманды,,ИмяФайлаХранилища);
	ДобавитьВКомандуКлючЗначение(ТекстКоманды,"-ne");
	ДобавитьВКомандуКлючЗначение(ТекстКоманды,"-ex",КаталогВыгрузкиФайлов);
	ДобавитьВКомандуКлючЗначение(ТекстКоманды,"USERS,HISTORY,VERSIONS,OBJECTS");
	
	ВывестиСообщение("ТекстКоманды: " + ТекстКоманды);
	ВывестиСообщение("Выгрузка хранилища в файлы");
	КодВозврата = ВыполнитьКоманду(ТекстКоманды);
	Если КодВозврата <> 0 Тогда
		ОписаниеОшибки = "При выгрузке хранилища в файлы XML произошла ошибка";
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;	
	
	ВывестиСообщение("Завершена выгрузка хранилища в файлы");
	
	УдалитьФайлы(мИмяФайлаДляTool_1CD);
	
	ВывестиСообщение("Удалили временный файл: " + мИмяФайлаДляTool_1CD);
	
	РезультатФункции = Новый Структура();
	РезультатФункции.Вставить("ИмяФайлаUSERS",КаталогВыгрузкиФайлов + "\USERS.xml");
	РезультатФункции.Вставить("ИмяФайлаHISTORY",КаталогВыгрузкиФайлов + "\HISTORY.xml");
	РезультатФункции.Вставить("ИмяФайлаVERSIONS",КаталогВыгрузкиФайлов + "\VERSIONS.xml");
	РезультатФункции.Вставить("ИмяФайлаOBJECTS",КаталогВыгрузкиФайлов + "\OBJECTS.xml");
	
	Возврат РезультатФункции;
КонецФункции

Функция СоздатьКоманду(Приложение)
	
	ТекстКоманды = """" + Приложение + """";
	Возврат ТекстКоманды;
	
КонецФункции

Функция ВыполнитьКоманду(ТекстКоманды)
	КодВозврата = Неопределено;
	ЗапуститьПриложение(ТекстКоманды,, Истина, КодВозврата);
	Возврат КодВозврата;
	
КонецФункции

Процедура ДобавитьВКомандуКлючЗначение(ТекстКоманды, Ключ, Значение = Неопределено)
	
	Если Значение = Неопределено Тогда
		ТекстКоманды = ТекстКоманды + " " + Ключ;
	Иначе	
		ТекстКоманды = ТекстКоманды + " " + Ключ + " """ + Экранировать(Значение) + """";
	КонецЕсли;
		
КонецПроцедуры

Функция Экранировать(Значение)
	
	Возврат СтрЗаменить(Значение, """", """""");	
	
КонецФункции

Процедура ВывестиСообщение(ТекстСообщения)
	Если НЕ ВыводитьОтладочныеСообщения Тогда
		Возврат;
	Конецесли;
	
	Сообщить("ОТЛАДКА "+ТекущаяДата() + ": "+ТекстСообщения);
КонецПроцедуры 

Процедура УдалитьВременныеФайлы(РезультатВыгрузки)
	Для каждого СтрокаРезультатВыгрузки из РезультатВыгрузки цикл
		ИмяФайла = СтрокаРезультатВыгрузки.Значение;
		УдалитьФайлы(ИмяФайла);		
		ВывестиСообщение("Удалили временный файл: " + ИмяФайла);
	Конеццикла;	
КонецПроцедуры 

мЭтоОтладка = Ложь;
мИмяКлассаОбъекта_Конфигурация = "Конфигурация";