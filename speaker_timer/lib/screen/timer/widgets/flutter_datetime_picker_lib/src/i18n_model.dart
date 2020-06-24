enum LocaleType {
  en,
  it,
  fr,
  es,
  pt,
}

final _i18nModel = {
  'en': {
    'rest time': 'Rest Time',
    'repeat': 'Repeat',
    'hour': 'Hour',
    'minute': 'Minute',
    'second': 'Second',
    'cancel': 'Cancel',
    'done': 'Done',
    'today': 'Today',
    'monthShort': [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ],
    'monthLong': [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ],
    'day': ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'],
    'am': 'AM',
    'pm': 'PM'
  },
  'it': {
    'rest time': 'Tempo di Riposo',
    'repeat': 'Ripetere',
    'hour': 'Ora',
    'minute': 'Minuto',
    'second': 'Secondo',
    'cancel': 'Annulla',
    'done': 'Conferma',
    'today': 'Oggi',
    'monthShort': [
      'Gen',
      'Feb',
      'Mar',
      'Apr',
      'Mag',
      'Giu',
      'Lug',
      'Ago',
      'Set',
      'Ott',
      'Nov',
      'Dic'
    ],
    'monthLong': [
      'Gennaio',
      'Febbraio',
      'Marzo',
      'Aprile',
      'Maggio',
      'Giugno',
      'Luglio',
      'Agosto',
      'Settembre',
      'Ottobre',
      'Novembre',
      'Dicembre'
    ],
    'day': ['Lun', 'Mar', 'Mer', 'Giov', 'Ven', 'Sab', 'Dom'],
    'am': 'AM',
    'pm': 'PM'
  },
  'fr': {
    'rest time': 'Temps de Repos',
    'repeat': 'Répéter',
    'hour': 'Heure',
    'minute': 'Minute',
    'second': 'Second',
    'cancel': 'Annuler',
    'done': 'Confirmer',
    'today': "Aujourd'hui",
    'monthShort': [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Juin',
      'Juil',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc'
    ],
    'monthLong': [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ],
    'day': ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
    'am': 'AM',
    'pm': 'PM'
  },
  'es': {
    'rest time': 'Tiempo de Descanso',
    'repeat': 'Repetir',
    'hour': 'Hora',
    'minute': 'Minuto',
    'second': 'Segundo',
    'cancel': 'Cancelar',
    'done': 'Confirmar',
    'today': 'Hoy',
    'monthShort': [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ],
    'monthLong': [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ],
    'day': ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
    'am': 'AM',
    'pm': 'PM'
  },
  'pt': {
    'rest time': 'Tempo de Repouso',
    'repeat': 'Repetir',
    'hour': 'Hora',
    'minute': 'Minuto',
    'second': 'Segundo',
    'cancel': 'Cancelar',
    'done': 'Confirmar',
    'today': 'Hoje',
    'monthShort': [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez'
    ],
    'monthLong': [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ],
    'day': ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'],
    'am': 'AM',
    'pm': 'PM'
  },
};
//get international object
Map<String, dynamic> i18nObjInLocale(LocaleType type) {
  switch (type) {
    case LocaleType.it:
      return _i18nModel['it'];
    case LocaleType.fr:
      return _i18nModel['fr'];
    case LocaleType.es:
      return _i18nModel['es'];
    case LocaleType.pt:
      return _i18nModel['pt'];
    default:
      return _i18nModel['en'];
  }
}
