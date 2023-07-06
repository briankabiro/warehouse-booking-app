import dayjs from 'dayjs';
var localizedFormat = require('dayjs/plugin/localizedFormat')
dayjs.extend(localizedFormat);

export const formatTimetoHHMM = (time) => {
  return dayjs(time).format("LT");
}

export const formatTimeToDay = (date) => {
  return dayjs(date).format('LL');
}

export const convertTimeFormat = (time) => {
  const [hours, minutes] = time.split(':');

  return `${hours}:${minutes}:00`;
}