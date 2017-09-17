//Kontrola formulare pro zadavani vysledku
var ff1 = new Array();
ff1[0] = new MeSelect("Jméno - domácí hráč 1. pozice", 0);
ff1[1] = new MeText("Skóre - domácí hráč 1.pozice", false);
ff1[2] = new MeSelect("Jméno - hostující hráč 1. pozice", 0);
ff1[3] = new MeText("Skóre - hostující hráč 1.pozice", false);
ff1[4] = new MeSelect("Jméno - domácí hráč 2. pozice", 0);
ff1[5] = new MeText("Skóre - domácí hráč 2.pozice", false);
ff1[6] = new MeSelect("Jméno - hostující hráč 2. pozice", 0);
ff1[7] = new MeText("Skóre - hostující hráč 2.pozice", false);
ff1[8] = new MeSelect("Jméno - domácí hráč 3. pozice", 0);
ff1[9] = new MeText("Skóre - domácí hráč 3.pozice", false);
ff1[10] = new MeSelect("Jméno - hostující hráč 3. pozice", 0);
ff1[11] = new MeText("Skóre - hostující hráč 3.pozice", false);

function MeText(strName, fAllowEmpty) {
    this.strName = strName;
    this.fAllowEmpty = fAllowEmpty;
    this.Validate = function(field) {
        if ((!this.fAllowEmpty) && (field.value === "")) {
            alert('Vyplňte hodnotu do pole "' + this.strName + '".');
            field.focus();
            return false;
        } else if (isNaN(parseInt(field.value)) || (field.value > 300 || field.value < 0)) {
            alert('Nesprávná hodnota pole: "' + this.strName + '".\n(rozsah platných hodnot 0-300)');
            field.focus();
            return false;
        }
        return true;
    };
}

function MeSelect(strName, iFirstIndex) {
    this.strName = strName;
    this.iFirstIndex = iFirstIndex;
    this.Validate = function(field) {
        if (field.selectedIndex < this.iFirstIndex) {
            alert('Není vybrána položka pro: "' + this.strName + '".');
            field.focus();
            return false;
        }
        return true;
    };
}

function Validate(theForm, arr) {
    for (var i = 0; i < theForm.length; i++) {
        if (arr[i]) {
            if (!arr[i].Validate(theForm.elements[i]))
                return false;
        }
    }
    return true;
}
