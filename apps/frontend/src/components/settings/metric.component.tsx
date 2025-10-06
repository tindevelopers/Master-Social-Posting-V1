'use client';

import { Select } from '@gitroom/react/form/select';
import React, { useState, useEffect } from 'react';
import { isUSCitizen } from '@gitroom/frontend/components/launches/helpers/isuscitizen.utils';
import timezones from 'timezones-list';
const dateMetrics = [
  { label: 'AM:PM', value: 'US' },
  { label: '24 hours', value: 'GLOBAL' },
];

import dayjs from 'dayjs';
import timezone from 'dayjs/plugin/timezone';
dayjs.extend(timezone);

const MetricComponent = () => {
  // Initialize with null to avoid hydration mismatch
  const [currentMetric, setCurrentMetric] = useState<boolean | null>(null);
  const [timezone, setTimezone] = useState<string | null>(null);

  // Load from localStorage only on client-side after mount
  useEffect(() => {
    setCurrentMetric(isUSCitizen());
    setTimezone(localStorage.getItem('timezone') || dayjs.tz.guess());
  }, []);
  const changeMetric = (event: React.ChangeEvent<HTMLSelectElement>) => {
    const value = event.target.value;
    setCurrentMetric(value === 'US');
    localStorage.setItem('isUS', value);
  };

  const changeTimezone = (event: React.ChangeEvent<HTMLSelectElement>) => {
    const value = event.target.value;
    console.log(value);
    setTimezone(value);
    localStorage.setItem('timezone', value);
    dayjs.tz.setDefault(value);
  };

  // Don't render until client-side hydration is complete
  if (currentMetric === null) {
    return (
      <div className="my-[16px] mt-[16px] bg-sixth border-fifth border rounded-[4px] p-[24px] flex flex-col gap-[24px]">
        <div className="mt-[4px]">Date Metrics</div>
        <div className="animate-pulse h-10 bg-fifth rounded"></div>
      </div>
    );
  }

  return (
    <div className="my-[16px] mt-[16px] bg-sixth border-fifth border rounded-[4px] p-[24px] flex flex-col gap-[24px]">
      <div className="mt-[4px]">Date Metrics</div>
      <Select name="metric" disableForm={true} label="" onChange={changeMetric}>
        {dateMetrics.map((metric) => (
          <option
            key={metric.value}
            value={metric.value}
            selected={currentMetric === (metric.value === 'US')}
          >
            {metric.label}
          </option>
        ))}
      </Select>

      {/*<div className="mt-[4px]">Current Timezone</div>*/}
      {/*<Select*/}
      {/*  name="timezone"*/}
      {/*  disableForm={true}*/}
      {/*  label=""*/}
      {/*  onChange={changeTimezone}*/}
      {/*>*/}
      {/*  {timezones.map((metric) => (*/}
      {/*    <option*/}
      {/*      key={metric.name}*/}
      {/*      value={metric.tzCode}*/}
      {/*      selected={metric.tzCode === timezone}*/}
      {/*    >*/}
      {/*      {metric.label}*/}
      {/*    </option>*/}
      {/*  ))}*/}
      {/*</Select>*/}
    </div>
  );
};

export default MetricComponent;
