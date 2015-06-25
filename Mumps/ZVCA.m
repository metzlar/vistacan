ZVCA    ; VistACan mumps routines 
        ; author: Ivan Metzlar <metzlar@gmail.com>
        ;
VERSION(RESULT) ; Get this GT.M version
        ; RESULT (reference) a result paramater to hold the version
        S RESULT=$zversion_" "_$horolog
        Q
LOCATIONS(RESULT) ; List all hospital locations (File no. 44)
        ; RESULT (reference) a result parameter to hold all
        ; locations pointing to their ien
        M RESULT=^SC("B")
        D B2MAP(.RESULT)
        Q
NOTETEMPLATES(RESULT) ; List all note templates
        ; RESULT (reference) a result parameter to hold all document
        ; definition names pointing to its ien
        M RESULT=^TIU(8925.1,"B")
        D B2MAP(.RESULT)
        Q
B2MAP(IO) ; Turn an index to a hash map
        N KEY,VAL S KEY="",VAL=""
        F  S KEY=$O(IO(KEY)) Q:KEY=""  D
        . S VAL=$O(IO(KEY,0))
        . S IO(KEY)=VAL
        . K IO(KEY,VAL)
        Q
PATIENTCNT(RESULT) ; Count all patients
        N HASH,CNT,X
        S CNT=0,X=""
        M HASH=^DPT("B") ; get the B index of all patients
        D B2MAP(.HASH) ; Turn the list into a hash map
        F  S X=$O(HASH(X)) Q:X=""  S CNT=CNT+1
        S RESULT=CNT
        Q
CREATEVISITWNOTE(NOTEIEN,PRV,DFN,DIA,CONTENT,TITLE,VLOC) ; create a visit with a note
        ; NOTEIEN - return parameter (the ien to the note created)
        ; PRV - ien of new person responsible
        ; DFN - patient IEN
        ; DIA - icd code (doesnt work at this moment)
        ; CONTENT - content of the note (text)
        ; TITLE - ien for the document definition (template) to use
        N DUZ,VDT
        D DT^DICRW
        S DUZ=PRV
        ; create the visit
        S VDT=$$CREATEVISIT(DFN,PRV,"A",VLOC)
        ; create a note w/TITLE for patient w/DFN
        ; at location VLOC
        N NIEN S NIEN=""
        N VSIT,VSTR,SUPPRESS,NOASF,TIUX,TIUY
        S VSIT="",VSTR="11;"_VDT_";I",SUPPRESS="0",NOASF="1"
        D MAKE^TIUSRVP(.NIEN,DFN,TITLE,VDT,VLOC,VSIT,.TIUX,VSTR,SUPPRESS,NOASF)
        S TIUX("TEXT",1,0)=CONTENT
        S TIUX("POV")=DIA
        S TIUX("HDR")="1"_U_"1"
        S TIUY=""
        D SETTEXT^TIUSRVPT(.TIUY,NIEN,.TIUX,SUPPRESS)
        M NOTEIEN=NIEN
        Q
CREATEVISIT(DFN,PRV,IORA,VLOC) ; create a visit and return its timestamp
        N VDT S VDT=""
        D DT^ORWU(.VDT,"NOW")
        ; create some required parameters
        N OK,NIEN,VSTR,SUPPRESS,PCELIST
        S NIEN="",VSTR=VLOC_";"_VDT_";"_IORA,SUPPRESS="0"
        ; create a visit with diagnose DIA
        S DIATEXT="Shoulder Injury (ICD-9-CM 912.8)"
        S OK=""
        S PCELIST(1)="HDR"_U_"1"_U_U_VSTR
        S PCELIST(2)="VST"_U_"DT"_U_VDT
        S PCELIST(3)="VST"_U_"PT"_U_DFN
        S PCELIST(4)="VST"_U_"HL"_U_VLOC
        S PCELIST(5)="VST"_U_"VC"_U_IORA
        S PCELIST(6)="PRV"_U_PRV_U_U_U_U_"1"
        S PCELIST(7)="POV+"_U_DIA_U_U_DIATEXT_U_"1"_U_PRV_U_"0"_U_U_U_"1"
        D SAVE^ORWPCE(.OK,.PCELIST,NIEN,VLOC)
        Q VDT
