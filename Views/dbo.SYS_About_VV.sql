SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[SYS_About_VV]
WITH ENCRYPTION
AS

SELECT     
'' AS AresLogo, 
'' AS VisionLogo, 
'' AS Product, 
'Eurotronic Sp. z o.o.' AS Copyright, 
'ul. Bitwy Warszawskiej 1920r nr 7 <br> Business Center Bitwy Warszawskiej / bud. C / 6p.' AS Address, 
'02-366' AS ZipCode, 
'Warszawa' AS City, 
'+48 22 666 10 82' AS Phone1, 
'+48 22 665 90 36' AS Phone2, 
'<a href="mailto:biuro@eurotronic.net.pl">biuro@eurotronic.net.pl</a>' AS Email, 
'<a href="http://www.eurotronic.net.pl" target="_blank">http://www.eurotronic.net.pl</a>' AS WWW, 
(SELECT SettingValue FROM SYSettings WHERE KeyCode = 'LIC_COMPANY') AS LicenseFor, 
(SELECT SettingValue FROM SYSettings WHERE KeyCode = 'LIC_STREET') AS ClientAddress, 
(SELECT SettingValue FROM SYSettings WHERE KeyCode = 'LIC_ZIP') AS ClientZipCode, 
(SELECT SettingValue FROM SYSettings WHERE KeyCode = 'LIC_CITY') AS ClientCity, 
(SELECT SettingValue FROM SYSettings WHERE KeyCode = 'LIC_PHONE') AS ClientPhone, 
(SELECT SettingValue FROM SYSettings WHERE KeyCode = 'LIC_FAX') AS ClientFax, 
(SELECT SettingValue FROM SYSettings WHERE KeyCode = 'LIC_EMAIL') AS ClientEmail, 
(SELECT SettingValue FROM SYSettings WHERE KeyCode = 'LIC_WWW') AS ClientWWW, 
(SELECT SettingValue FROM SYSettings WHERE KeyCode = 'LIC_TRN') AS ClientTRN, 
(SELECT SettingValue FROM SYSettings WHERE KeyCode = 'LIC_BANK') AS ClientBANK, 
(SELECT SettingValue FROM SYSettings WHERE KeyCode = 'LIC_ACCOUNT') AS ClientACCOUNT, 
'<br/><br/>System <b>ZMT/CRANE</b> (powstały na bazie systemu ARES VISION) chroniony jest prawami autorskimi. Kopiowanie, rozpowszechnianie oraz wykorzystywanie systemu <b>ZMT/CRANE</b> bez zgody firmy <b>Eurotronic Sp. z o.o.</b> jest zabronione. Naruszenie i / lub złamanie praw autorskich grozi pociągnięciem do odpowiedzialności cywilnej i karnej. ' AS Caution
GO