C IE NBRE DE STOREY UTILISEES POUR DEFINIR LES 2X2 PSEUDO TOURS
C    DE LA TRACE NETRA  (IE<21)
C ISTO JSTO KSTO ESTO  TETA,PHI,STAK,ENERGIE DES STOREYS
C E4CLU ENERGIE TOTALE DES 2X2 PSEUDOTOURS
C
      PARAMETER (NSTO4=20,NETRA=5)
C   DROITE COS DIR DE LA PART DE NUMERO BANQUE CLUSTER NETRA
C   NTOW NBRE DE STACKS BARRIL + EC TRAVERSES
C  XTOW            POINTS D ENTREE ET SORTIE STACKS
      PARAMETER (NTOWMX=12)
      COMMON/E4COM1/NBE4ST(NETRA),ISTO(NETRA,NSTO4),
     &JSTO(NETRA,NSTO4),KSTO(NETRA,NSTO4),
     &ESTO(NETRA,NSTO4),E4CLU(NETRA),
     &XSTO(NETRA,NSTO4),YSTO(NETRA,NSTO4),
     &ZSTO(NETRA,NSTO4),
     &DROITE(NETRA,3),NTOW(NETRA),XTOW(NETRA,NTOWMX,3)