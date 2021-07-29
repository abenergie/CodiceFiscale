//
//  FiscalCodeManager.swift
//  ClientDataCollection
//
//  Created by Luigi Aiello on 13/05/2019.
//  Copyright © 2019 Luigi Aiello. All rights reserved.
//

import UIKit

// Wikipedia codice fiscale: https://it.wikipedia.org/wiki/Codice_fiscale

public class FiscalCode: NSObject {
    public var name: String
    public var surname: String
    public var gender: Gender
    public var date: Date
    public var town: String
    public var province: String
    
    public init(name: String, surname: String, gender: Gender, date: Date, town: String, province: String) {
        self.name = name
        self.surname = surname
        self.gender = gender
        self.date = date
        self.town = town
        self.province = province
    }
}

public struct LocalAuthority: Decodable {
    public var province: String
    public var town: String
    public var code: String
    
    // MARK: - Init
    
    public init(province: String, town: String, code: String) {
        self.province = province
        self.town = province
        self.code = province
    }
    
    public init?(province: String?, town: String?, code: String?) {
        guard
            let safeProvince = province,
            let safeTown = town,
            let safeCode = code
        else {
            return nil
        }
        
        self.init(province: safeProvince, town: safeTown, code: safeCode)
    }
}
public class FiscalCodeManager: NSObject {
    
    // MARK: - Varibles
    public var localAuthorites: [LocalAuthority]?
    private let vowels = CharacterSet(charactersIn: "aeiou")
    private let monthCodes = "XABCDEHLMPRST"
    private let charactersLimit: Int = 3

    // MARK: - Init
    public override init() {
        localAuthorites = JSONSerializer.serializeFromPODFileJSON(modelType: [LocalAuthority].self, input: "LocalAuthorites", type: "json")
    }

    public init(localAuthorietsFileName fileName: String, localAuthorietsExtension fileExtension: String) {
        localAuthorites = JSONSerializer.serializeFromFileJSON(modelType: [LocalAuthority].self, input: fileName, type: fileExtension)
    }

    public init(localAuthoriets: [LocalAuthority]) {
        localAuthorites = localAuthoriets
    }
    
    // MARK: - Public Methods
    /**
     Calcola codice fiscale

     - returns: Codice fiscale
     
     - parameters:
        - name: Nome della persone di cui calcolare il codice fiscale
        - surname: Cognome della persone di cui calcolare il codice fiscale
        - gender: Sesso della persone di cui calcolare il codice fiscale
        - date: Data di nascita della persone di cui calcolare il codice fiscale
        - town: Città di nascita della persone di cui calcolare il codice fiscale
        - province: Provincia di nascita della persone di cui calcolare il codice fiscale
     */
    public func calculate(name: String, surname: String, gender: Gender, date: Date, town: String, province: String) -> String? {
        let data = FiscalCode(name: name, surname: surname, gender: gender, date: date, town: town, province: province)

        return calculate(data: data)
    }

    /**
     Calcola codice fiscale

     - returns: Codice fiscale

     - parameter fiscalCodeData: Oggetto che comprende i dati essenziali per calcolare il codice fiscale
     */
    public func calculate(fiscalCodeData data: FiscalCode) -> String? {
        return calculate(data: data)
    }

    public func retriveInformationFrom(fiscalCode: String) -> FiscalCode? {
        guard fiscalCode.isValidFiscalCode else {
            return nil
        }
        
        let surname = fiscalCode[0..<3]
        let name = fiscalCode[3..<6]
        let year = fiscalCode[6..<8]
        let month = fiscalCode[8]
        let day = fiscalCode[9..<11]
        let cityCode = fiscalCode[11..<15]

        guard
            let gender = getGender(day),
            let date = getNormalizedDate(year: year, month: month, day: day, gender: gender),
            let localAuthority = findCityBy(cityCode)
        else {
            return nil
        }

        return FiscalCode(name: name,
                          surname: surname,
                          gender: gender,
                          date: date,
                          town: localAuthority.town,
                          province: localAuthority.province)
    }

    // MARK: - Private methods
    private func calculate(data: FiscalCode) -> String? {
        let cfSurname = sanitizeSurname(input: data.surname)
        let cfName = sanitizeName(input: data.name)
        let cfDate = sanitazeDate(input: data.date, sex: data.gender)

        guard let cfCityCode = findCityCode(data.town) else {
            return nil
        }

        let partialFiscalCode = "\(cfSurname)\(cfName)\(cfDate)\(cfCityCode)".uppercased()

        guard let cfCheckDigit = calculateCin(input: partialFiscalCode) else {
            return nil
        }

        let fiscalCode = "\(partialFiscalCode)\(cfCheckDigit)"

        guard fiscalCode.isValidFiscalCode else {
            return nil
        }

        return fiscalCode
    }

    /**
     Cognome (3 lettere)

     Vengono prese le consonanti del cognome (o dei cognomi, se ve ne è più di uno) nel loro ordine (primo cognome, di seguito il secondo e così via).
     Se le consonanti sono insufficienti, si prelevano anche le vocali (se sono sufficienti le consonanti si prelevano la prima, la seconda e la terza
     consonante), sempre nel loro ordine e, comunque, le vocali vengono riportate dopo le consonanti (per esempio: Rosi → RSO). Nel caso in cui un cognome
     abbia meno di tre lettere, la parte di codice viene completata aggiungendo la lettera X (per esempio: Fo → FOX). Per le donne, viene preso in
     considerazione il solo cognome da nubile.
     */
    private func sanitizeSurname(input: String) -> String {
        let dirtRemoved = removeDirt(input: input)
        let consVowels = divedeConsonantsAndVowels(input: dirtRemoved)

        var stringsUnion = "\(consVowels.consonants)\(consVowels.vowels)"

        if stringsUnion.count < charactersLimit {
            let charactersToAdd = String(repeating: "X", count: charactersLimit - dirtRemoved.count)
            stringsUnion.append(charactersToAdd)
        }

        return stringsUnion[0..<charactersLimit]
    }

    /**
     Nome (3 lettere)

     Vengono prese le consonanti del nome (o dei nomi, se ve ne è più di uno) nel loro ordine (primo nome, di seguito il secondo e così via) in questo modo:
     se il nome contiene quattro o più consonanti, si scelgono la prima, la terza e la quarta (per esempio: Gianfranco → GFR),
     altrimenti le prime tre in ordine (per esempio: Tiziana → TZN). Se il nome non ha consonanti a sufficienza,
     si prendono anche le vocali; in ogni caso le vocali vengono riportate dopo le consonanti (per esempio: Luca → LCU).
     Nel caso in cui il nome abbia meno di tre lettere la parte di codice viene completata aggiungendo la lettera X.
     */
    private func sanitizeName(input: String) -> String {
        let dirtRemoved = removeDirt(input: input)
        let consVowels = divedeConsonantsAndVowels(input: dirtRemoved)

        var stringsUnion = "\(consVowels.consonants)\(consVowels.vowels)"

        var cfName = String()

        if stringsUnion.count < charactersLimit {
            let charactersToAdd = String(repeating: "X", count: charactersLimit - dirtRemoved.count)
            stringsUnion.append(charactersToAdd)
            cfName = stringsUnion[0..<charactersLimit]
        } else {
            if consVowels.consonants.count > 3 {
                cfName.append(consVowels.consonants[0])
                cfName.append(consVowels.consonants[2])
                cfName.append(consVowels.consonants[3])
            } else {
                cfName = stringsUnion[0..<charactersLimit]
            }
        }

        return cfName
    }

    /**
     Data di nascita

     Anno di nascita (due cifre): si prendono le ultime due cifre dell'anno di nascita;
     Mese di nascita (una lettera): a ogni mese dell'anno viene associata una lettera in base a questa tabella:
     Lettera    Mese        Lettera     Mese        Lettera     Mese
     A          gennaio     E           maggio      P           settembre
     B          febbraio    H           giugno      R           ottobre
     C          marzo       L           luglio      S           novembre
     D          aprile      M           agosto      T           dicembre
     Giorno di nascita e sesso (due cifre): si prendono le due cifre del giorno di nascita (se è compreso tra 1 e 9 si pone uno zero come prima cifra); per i soggetti di sesso femminile, a tale cifra va sommato il numero 40. In questo modo il campo contiene la doppia informazione giorno di nascita e sesso.
     */
    private func sanitazeDate(input: Date, sex: Gender) -> String {
        var day: String
        let month = input.component(.month)
        let monthCode = monthCodes[month]
        let year = input.formatted("yy")

        switch sex {
        case .female:
            var dayComponent = input.component(.day)
            dayComponent += 40
            day = "\(dayComponent)"
        case .male:
            day = input.formatted("dd")
        }

        return "\(year)\(monthCode)\(day)"
    }

    /**
     Comune (o Stato) di nascita (quattro caratteri alfanumerici)

     Per identificare il comune di nascita si utilizza il codice detto Belfiore, composto da una lettera e tre cifre numeriche.
     Per i nati al di fuori del territorio italiano, sia cittadini stranieri sia cittadini italiani nati all'estero,
     si considera lo stato estero di nascita; in tal caso la sigla inizia con la lettera Z, seguita dal numero identificativo dello stato.
     Il codice Belfiore è lo stesso usato per il nuovo Codice catastale.
     */
    private func findCityCode(_ town: String) -> String? {
        guard let localAuthorites = self.localAuthorites else {
            return nil
        }

        let localAuthority = localAuthorites.first(where: { $0.town.lowercased() == town.lowercased() })

        return localAuthority?.code
    }

    /**
     Codice di controllo

     https://it.wikipedia.org/wiki/Codice_fiscale
     */
    private func calculateCin(input: String) -> String? {
        guard
            let evens = JSONSerializer.serializeFromPODFileJSON(modelType: [String: Int].self, input: "Evens", type: "json"),
            let odds = JSONSerializer.serializeFromPODFileJSON(modelType: [String: Int].self, input: "Odds", type: "json")
        else {
            return nil
        }

        let ctrlChar = [0: "A", 1: "B", 2: "C", 3: "D", 4: "E", 5: "F", 6: "G", 7: "H", 8: "I", 9: "J", 10: "K", 11: "L", 12: "M", 13: "N", 14: "O", 15: "P", 16: "Q", 17: "R", 18: "S", 19: "T", 20: "U", 21: "V", 22: "W", 23: "X", 24: "Y", 25: "Z"]

        var sumEvens = 0
        var sumOdds = 0

        var evensCharacters = String()
        var oddsCharacaters = String()

        for (index, character) in input.enumerated() {
            if (index + 1) % 2 == 0 {
                evensCharacters.append(character)
                sumEvens += evens[String(character)] ?? 0
            } else {
                oddsCharacaters.append(character)
                sumOdds += odds[String(character)] ?? 0
            }
        }

        return ctrlChar[(sumEvens + sumOdds) % 26]
    }

    // MARK: - Reverse
    private func findCityBy( _ code: String) -> LocalAuthority? {
        guard let localAuthorites = self.localAuthorites else {
            return nil
        }

        return localAuthorites.first(where: { $0.code == code })
    }

    private func getGender(_ day: String) -> Gender? {
        guard let intDay = Int(day) else {
            return nil
        }

        return intDay > 40 ? .female : .male
    }

    private func getNormalizedDate(year: String, month: Character, day: String, gender: Gender) -> Date? {
        guard
            var intDay = Int(day),
            var intYear = Int(year),
            let intMonth = monthCodes.firstIndex(of: month)
        else {
            return nil
        }

        let now = Date()
        let pos = monthCodes.distance(from: monthCodes.startIndex, to: intMonth)

        // Calculate Days
        if gender == .female {
            intDay -= 40
        }

        intYear += (now.component(.year) > intYear + 2000) ? 2000 : 1900

        let dayFormat = intDay > 9 ? "dd" : "d"
        let monthFormat = pos > 9 ? "MM" : "M"
        let yearFormat = "yyyy"

        return Date.from(string: "\(intDay) \(pos) \(intYear)", withFormat: "\(dayFormat) \(monthFormat) \(yearFormat)")
    }

    // MARK: - Helpers
    private func removeDirt(input: String) -> String {
        let dirtRemoved = input
            .lowercased()
            .components(separatedBy: .whitespacesAndNewlines)
            .joined()
            .folding(options: .diacriticInsensitive, locale: .current)

        return dirtRemoved
    }

    private func divedeConsonantsAndVowels(input: String) -> (consonants: String, vowels: String) {
        var vowelsCharacters = String()
        var consonantsCharacters = String()

        for char in input {
            if String(char).rangeOfCharacter(from: vowels) != nil {
                vowelsCharacters.append(char)
            } else {
                consonantsCharacters.append(char)
            }
        }

        return (consonantsCharacters, vowelsCharacters)
    }
}
