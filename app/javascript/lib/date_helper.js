/**
 * Module to assist with manipulating dates
 */

export function getLocalISOString(date) {
  const offset = date.getTimezoneOffset();
  const offsetAbs = Math.abs(offset);
  const isoString = new Date(date.getTime() - offset * 60 * 1000).toISOString();

  return `${isoString.slice(0, -1)}${offset > 0 ? "-" : "+"}${String(Math.floor(offsetAbs / 60)).padStart(2, "0")}:${String(offsetAbs % 60).padStart(2, "0")}`;
}