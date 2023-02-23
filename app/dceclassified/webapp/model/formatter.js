sap.ui.define([], function () {
	"use strict";

	return {

		/**
		 * Rounds the number unit value to 2 digits
		 * @public
		 * @param {string} sValue the number string to be rounded
		 * @returns {string} sValue with 2 digits rounded
		 */
		numberUnit: function (sValue) {
			if (!sValue) {
				return "";
			}
			return parseFloat(sValue).toFixed(2);
		},

		formatterDateObj: function (sDate) {
			if (sDate) {
				var oDate = new Date(sDate);
				var iDateWithOffset = oDate.getTime() - (oDate.getTimezoneOffset() * 60000);
				sDate = new Date(iDateWithOffset);

				var time = sDate.toJSON().split("T")[1].split(":");
				var date = sDate.toJSON().split("T")[0];
				return date + " " + time[0] + ":" + time[1];
			} else {
				return "/";
			}
		},
		formatterDate: function (sDate) {
			if (sDate) {
				var oDate = new Date(sDate);
				var iDateWithOffset = oDate.getTime() - (oDate.getTimezoneOffset() * 60000);
				sDate = new Date(iDateWithOffset);

				var time = sDate.toJSON().split("T")[1].split(":");
				var date = sDate.toJSON().split("T")[0];
				return date + " " + time[0] + ":" + time[1];
			} else {
				return sDate;
			}
		},

		status: function (status) {
			var stat;
			switch (status) {
			case -4:
				stat = "To be reviewed";
				break;
			case -3:
				stat = "Attribute settings pending";
				break;
			case -2:
				stat = "Rejected";
				break;
			case -1:
				stat = "Archived";
				break;
			case 0:
				stat = "Created";
				break;
			case 1:
				stat = "Assigned";
				break;
			case 2:
				stat = "Under validation";
				break;
			case 3:
				stat = "Classified";
				break;
			case 4:
				stat = "Updated";
				break;
			}
			return stat;
		},

		formatterOnlyDate: function (sDate) {
			if (sDate) {
				var date = sDate.toJSON().split("T")[0];
				return date;
			} else {
				return "/";
			}
		},

		specialChar: function (sValue) {
			if (sValue) {
				sValue = sValue.replace(/lower than/g, "<");
				sValue = sValue.replace(/greater than/g, ">");
				sValue = sValue.replace(/equal to/g, "=");
				sValue = sValue.replace(/question mark/g, "?");
			}
			return sValue;
		},

		noSpecialChar: function (sValue) {
			if (sValue) {
				sValue = sValue.replace(/[<]/g, "lower than");
				sValue = sValue.replace(/[>]/g, "greater than");
				sValue = sValue.replace(/[=]/g, "equal to");
				sValue = sValue.replace(/[?]/g, "question mark");
			}
			return sValue;
		},

		yesNoAlways: function (sValue) {
			if (sValue === 0) {
				return "Yes";
			} else if (sValue === 2) {
				return "Always";
			} else {
				return "No";
			}
		},

		textToLink: function (sValue) {

			var urlRegex =
				/((?:(http|https|Http|Https|rtsp|Rtsp):\/\/(?:(?:[a-zA-Z0-9\$\-\_\.\+\!\*\'\(\)\,\;\?\&\=]|(?:\%[a-fA-F0-9]{2})){1,64}(?:\:(?:[a-zA-Z0-9\$\-\_\.\+\!\*\'\(\)\,\;\?\&\=]|(?:\%[a-fA-F0-9]{2})){1,25})?\@)?)?((?:(?:[a-zA-Z0-9][a-zA-Z0-9\-]{0,64}\.)+(?:(?:aero|arpa|asia|a[cdefgilmnoqrstuwxz])|(?:biz|b[abdefghijmnorstvwyz])|(?:cat|com|coop|c[acdfghiklmnoruvxyz])|d[ejkmoz]|(?:edu|e[cegrstu])|f[ijkmor]|(?:gov|g[abdefghilmnpqrstuwy])|h[kmnrtu]|(?:info|int|i[delmnoqrst])|(?:jobs|j[emop])|k[eghimnrwyz]|l[abcikrstuvy]|(?:mil|mobi|museum|m[acdghklmnopqrstuvwxyz])|(?:name|net|n[acefgilopruz])|(?:org|om)|(?:pro|p[aefghklmnrstwy])|qa|r[eouw]|s[abcdeghijklmnortuvyz]|(?:tel|travel|t[cdfghjklmnoprtvwz])|u[agkmsyz]|v[aceginu]|w[fs]|y[etu]|z[amw]))|(?:(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[0-9])))(?:\:\d{1,5})?)(\/(?:(?:[a-zA-Z0-9\;\/\?\:\@\&\=\#\~\-\.\+\!\*\'\(\)\,\_])|(?:\%[a-fA-F0-9]{2}))*)?(?:\b|$)/gi;
			return sValue.replace(urlRegex, function (url) {
				if (url.includes("http") === false && url.includes("https") === false && url.includes("Https") === false && url.includes("Http") ===
					false && url.includes("rtsp") === false && url.includes("Rtsp") === false) {
					return '<a href="' + 'http://' + url + '">' + url + '</a>';
				} else {
					return '<a href="' + url + '">' + url + '</a>';
				}
			});
		},

		specialCharAndTextToLink: function (sValue) {
			if (sValue) {
				sValue = sValue.replace(/lower than/g, "<");
				sValue = sValue.replace(/greater than/g, ">");
				sValue = sValue.replace(/equal to/g, "=");
				sValue = sValue.replace(/question mark/g, "?");
			}
			var urlRegex =
				/((?:(http|https|Http|Https|rtsp|Rtsp):\/\/(?:(?:[a-zA-Z0-9\$\-\_\.\+\!\*\'\(\)\,\;\?\&\=]|(?:\%[a-fA-F0-9]{2})){1,64}(?:\:(?:[a-zA-Z0-9\$\-\_\.\+\!\*\'\(\)\,\;\?\&\=]|(?:\%[a-fA-F0-9]{2})){1,25})?\@)?)?((?:(?:[a-zA-Z0-9][a-zA-Z0-9\-]{0,64}\.)+(?:(?:aero|arpa|asia|a[cdefgilmnoqrstuwxz])|(?:biz|b[abdefghijmnorstvwyz])|(?:cat|com|coop|c[acdfghiklmnoruvxyz])|d[ejkmoz]|(?:edu|e[cegrstu])|f[ijkmor]|(?:gov|g[abdefghilmnpqrstuwy])|h[kmnrtu]|(?:info|int|i[delmnoqrst])|(?:jobs|j[emop])|k[eghimnrwyz]|l[abcikrstuvy]|(?:mil|mobi|museum|m[acdghklmnopqrstuvwxyz])|(?:name|net|n[acefgilopruz])|(?:org|om)|(?:pro|p[aefghklmnrstwy])|qa|r[eouw]|s[abcdeghijklmnortuvyz]|(?:tel|travel|t[cdfghjklmnoprtvwz])|u[agkmsyz]|v[aceginu]|w[fs]|y[etu]|z[amw]))|(?:(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[0-9])))(?:\:\d{1,5})?)(\/(?:(?:[a-zA-Z0-9\;\/\?\:\@\&\=\#\~\-\.\+\!\*\'\(\)\,\_])|(?:\%[a-fA-F0-9]{2}))*)?(?:\b|$)/gi;
			return sValue.replace(urlRegex, function (url) {
				if (url.includes("http") === false && url.includes("https") === false && url.includes("Https") === false && url.includes("Http") ===
					false && url.includes("rtsp") === false && url.includes("Rtsp") === false) {
					return '<a href="' + 'http://' + url + '">' + url + '</a>';
				} else {
					return '<a href="' + url + '">' + url + '</a>';
				}
			});

		}
	};

});