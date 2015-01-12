ZVCA    ; VistACan mumps routines 
        ; author: Ivan Metzlar <metzlar@gmail.com>
        ;
CREATEVISITWNOTE(PRV,DFN,DIA,CONTENT) ;
        D DT^DICRW
        S DUZ=PRV
        S VDT=$$CREATEVISIT(DIA,DFN,PRV)
        ; create a general visit (1467) note for patient w/DFN 
        ; at location 11 (DR OFFICE)
        S NIEN=""
        S TITLE="1467",VLOC="11",VSIT="",VSTR="11;"_VDT_";I",SUPPRESS="0",NOASF="1"
        D MAKE^TIUSRVP(.NIEN,DFN,TITLE,VDT,VLOC,VSIT,.TIUX,VSTR,SUPPRESS,NOASF)  
        S TIUX("TEXT",1,0)=CONTENT
	S TIUX("POV")=DIA
        S TIUX("HDR")="1"_U_"1"
	S TIUY=""
	D SETTEXT^TIUSRVPT(.TIUY,NIEN,.TIUX,SUPPRESS)
        Q
CREATEVISIT(DIA,DFN,PRV) ; create a visit and return its timestamp
        S VDT=""
        D DT^ORWU(.VDT,"NOW")
				; create some required parameters
        S NIEN="",VLOC="11",VSTR="11;"_VDT_";I",SUPPRESS="0"
        ; create a visit with diagnose DIA 
        S DIATEXT="Shoulder Injury (ICD-9-CM 912.8)"
        S OK=""
        S PCELIST(1)="HDR"_U_"1"_U_U_VSTR
        S PCELIST(2)="VST"_U_"DT"_U_VDT
        S PCELIST(3)="VST"_U_"PT"_U_DFN
        S PCELIST(4)="VST"_U_"HL"_U_VLOC
	S PCELIST(5)="VST"_U_"VC"_U_"I" ; A??
        S PCELIST(6)="PRV"_U_PRV_U_U_U_U_"1"
	S PCELIST(7)="POV+^"_DIA_"^^"_DIATEXT_"^1^"_PRV_"^0^^^1"
	S PCELIST(8)="COM^1^@"
        D SAVE^ORWPCE(.OK,.PCELIST,NIEN,VLOC)
        Q VDT
