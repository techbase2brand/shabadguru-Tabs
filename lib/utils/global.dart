import 'dart:math';

import 'package:shabadguru/audio_service/audio_service.dart';

double widthOfScreen = 0.0;
double heightOfScreen = 0.0;

int getRandomNumberFromList() {
  var rng = Random();
  return rng.nextInt(playingListOfShabad!.length);
}

String getShortNameOfRaag(String raagTitle) {
  switch (raagTitle) {
    case 'Japji Sahib':
      return 'JS';
    case 'Sodar Rehras':
      return 'SR';

    case 'Kirtan Sohila':
      return 'KS';

    case 'Bara Maha':
      return 'BM';

    case 'Bavan Akhri':
      return 'BA';

    case 'Sukhmani Sahib':
      return 'SS';

    case 'Bavan Akhri (Bhagat Kabir Ji)':
      return 'BK';

    case 'Aasa Di Vaar':
      return 'AV';

    case 'Laavan':
      return 'LA';

    case 'Anand Sahib':
      return 'AS';

    case 'Dhakni Onkar':
      return 'DO';

    case 'Sidh Gosht':
      return 'SG';

    case 'Salok Bhagat Kabir Ji':
      return 'SK';

    case 'Salok Bhagat Farid Ji':
      return 'SF';

    case 'Salok Mehla 1':
      return 'S1';

    case 'Salok Mehla 3':
      return 'S3';

    case 'Salok Mehla 4':
      return 'S4';

    case 'Salok Mehla 5':
      return 'S5';

    case 'Salok Mehla 9':
      return 'S9';

    case 'Mudhavni Mehla 5':
      return 'M5';

    case 'Swaiyee Sri Mukhbak Mehla 5':
      return 'SM';

    case 'Raag Mala':
      return 'RM';

    case 'Sri Raag':
      return 'SR';

    case 'Raag Maajh':
      return 'RM';

    case 'Raag Gauri':
      return 'RG';

    case 'Raag Aasa':
      return 'RA';

    case 'Raag Gujri':
      return 'RG';

    case 'Raag Devgandhari':
      return 'RD';

    case 'Raag Bihagra':
      return 'RB';

    case 'Raag Vadhans':
      return 'RV';

    case 'Raag Sorath':
      return 'RS';

    case 'Raag Dhanasri':
      return 'RD';

    case 'Raag Jaitsri':
      return 'RJ';

    case 'Raag Todhi':
      return 'RT';

    case 'Raag Bairari':
      return 'RB';

    case 'Raag Tilang':
      return 'RT';

    case 'Raag Suhi':
      return 'RS';

    case 'Raag Bilawal':
      return 'RB';

    case 'Raag Gaund':
      return 'RG';

    case 'Raag Ramkali':
      return 'RR';

    case 'Raag Nat Narayan':
      return 'RN';

    case 'Raag Mali Gaura':
      return 'RG';

    case 'Raag Maaru':
      return 'RM';

    case 'Raag Tukhari':
      return 'RT';

    case 'Raag Kedara':
      return 'RK';

    case 'Raag Bhairon':
      return 'RB';

    case 'Raag Basant':
      return 'RB';

    case 'Raag Sarang':
      return 'RS';

    case 'Raag Malaar':
      return 'RM';

    case 'Raag Kaanra':
      return 'RK';

    case 'Raag Kalyaan':
      return 'RK';

    case 'Raag Parbhati':
      return 'RP';

    case 'Raag Jai Jai Vanti':
      return 'RV';

    case 'Salok Sainskriti':
      return 'SS';

    case 'Mehla 5 - Gatha':
      return 'MG';

    case 'Phuney - Mehla 5':
      return 'P5';

    case 'Chauboley - Mehla 5':
      return 'C5';

    case 'Salok Vaaran Naal Vadheek':
      return 'SV';

    case 'Sodar':
      return 'SO';

    case 'Sohila':
      return 'SO';

    default:
      return 'JP';
  }
}
