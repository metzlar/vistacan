ZVCA    ; VistACan mumps routines 
        ; author: Ivan Metzlar <metzlar@gmail.com>
        ;
CREATEVISITWNOTE(NOTEIEN,PRV,DFN,DIA,CONTENT) ;
        N DUZ,VDT
        D DT^DICRW
        S DUZ=PRV
				; create the visit
				S VDT=$$CREATEVISIT(DFN,PRV,"A")
        ; create a general visit (1467) note for patient w/DFN 
        ; at location 11 (DR OFFICE)
        N NIEN S NIEN=""
				N TITLE,VLOC,VSIT,VSTR,SUPPRESS,NOASF,TIUX,TIUY
        S TITLE="1467",VLOC="11",VSIT="",VSTR="11;"_VDT_";I",SUPPRESS="0",NOASF="1"
        D MAKE^TIUSRVP(.NIEN,DFN,TITLE,VDT,VLOC,VSIT,.TIUX,VSTR,SUPPRESS,NOASF)  
        S TIUX("TEXT",1,0)=CONTENT
				S TIUX("POV")=DIA
        S TIUX("HDR")="1"_U_"1"
				S TIUY=""
				D SETTEXT^TIUSRVPT(.TIUY,NIEN,.TIUX,SUPPRESS)
        M NOTEIEN=NIEN
        Q
CREATEVISIT(DFN,PRV,IORA) ; create a visit and return its timestamp
        N VDT S VDT=""
        D DT^ORWU(.VDT,"NOW")
				; create some required parameters
        N OK,NIEN,VLOC,VSTR,SUPPRESS,PCELIST
        S NIEN="",VLOC="11",VSTR="11;"_VDT_";"_IORA,SUPPRESS="0"
        S OK=""
        S PCELIST(1)="HDR"_U_"1"_U_U_VSTR
        S PCELIST(2)="VST"_U_"DT"_U_VDT
        S PCELIST(3)="VST"_U_"PT"_U_DFN
        S PCELIST(4)="VST"_U_"HL"_U_VLOC
				S PCELIST(5)="VST"_U_"VC"_U_IORA
        S PCELIST(6)="PRV"_U_PRV_U_U_U_U_"1"
				;S PCELIST(7)="POV+^100.0^^Leptospirosis icterohemorrhagica * (ICD-9-CM 100.0)^1^94^1^^^"
        D SAVE^ORWPCE(.OK,.PCELIST,NIEN,VLOC)
        Q VDT
