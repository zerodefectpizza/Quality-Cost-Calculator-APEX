import React, { useState, useEffect } from 'react';

const QualityCostCalculator = () => {
  // State Management
  const [language, setLanguage] = useState('EN');
  const [currency, setCurrency] = useState('EUR');
  const [displayUnit, setDisplayUnit] = useState('MILLION');
  const [opportunityCosts, setOpportunityCosts] = useState(false);
  
  // Input Values
  const [revenue, setRevenue] = useState(140);
  const [qualityPercentage, setQualityPercentage] = useState(6);
  const [prevention, setPrevention] = useState(10);
  const [appraisal, setAppraisal] = useState(20);
  const [internalDefect, setInternalDefect] = useState(30);
  const [externalDefect, setExternalDefect] = useState(40);
  
  // Opportunity Cost Values
  const [lostSales, setLostSales] = useState(5);
  const [customerChurn, setCustomerChurn] = useState(2);
  const [marketShareLoss, setMarketShareLoss] = useState(1);
  const [productivityLoss, setProductivityLoss] = useState(3);

  // Calculated Results
  const [results, setResults] = useState({});
  const [validationError, setValidationError] = useState('');

  // Translations
  const translations = {
    EN: {
      title: 'Quality Cost Calculator',
      subtitle: 'Comprehensive Cost of Quality Analysis Tool',
      revenue: 'Revenue',
      qualityBasis: 'Quality Cost Basis (% of Revenue)',
      costDistribution: 'Cost Distribution (%)',
      prevention: 'Prevention Costs',
      appraisal: 'Appraisal Costs',
      internalDefect: 'Internal Failure Costs',
      externalDefect: 'External Failure Costs',
      opportunityFactors: 'Opportunity Cost Factors (%)',
      lostSales: 'Lost Sales',
      customerChurn: 'Customer Churn',
      marketShareLoss: 'Market Share Loss',
      productivityLoss: 'Productivity Loss',
      results: 'Calculated Results',
      totalQualityCost: 'Total Quality Cost',
      totalOpportunityCost: 'Total Opportunity Cost',
      totalImpact: 'Total Cost of Poor Quality',
      calculate: 'Calculate',
      save: 'Save Calculation',
      export: 'Export',
      language: 'Language',
      currency: 'Currency',
      unit: 'Display Unit',
      enableOpportunity: 'Enable Opportunity Costs',
      percentageError: 'Values do not add up to 100%',
      costOfGoodQuality: 'Cost of Good Quality',
      costOfPoorQuality: 'Cost of Poor Quality'
    },
    DE: {
      title: 'Qualitätskostenrechner',
      subtitle: 'Umfassendes Tool zur Qualitätskostenanalyse',
      revenue: 'Umsatz',
      qualityBasis: 'Qualitätskostenbasis (% des Umsatzes)',
      costDistribution: 'Kostenverteilung (%)',
      prevention: 'Präventionskosten',
      appraisal: 'Bewertungskosten',
      internalDefect: 'Interne Fehlerkosten',
      externalDefect: 'Externe Fehlerkosten',
      opportunityFactors: 'Opportunitätskostenfaktoren (%)',
      lostSales: 'Entgangene Verkäufe',
      customerChurn: 'Kundenverlust',
      marketShareLoss: 'Marktanteilsverlust',
      productivityLoss: 'Produktivitätsverlust',
      results: 'Berechnete Ergebnisse',
      totalQualityCost: 'Gesamtqualitätskosten',
      totalOpportunityCost: 'Gesamte Opportunitätskosten',
      totalImpact: 'Gesamtkosten schlechter Qualität',
      calculate: 'Berechnen',
      save: 'Berechnung speichern',
      export: 'Exportieren',
      language: 'Sprache',
      currency: 'Währung',
      unit: 'Anzeigeeinheit',
      enableOpportunity: 'Opportunitätskosten aktivieren',
      percentageError: 'Werte ergeben nicht 100%',
      costOfGoodQuality: 'Kosten guter Qualität',
      costOfPoorQuality: 'Kosten schlechter Qualität'
    }
  };

  const t = translations[language];

  // Calculate results
  useEffect(() => {
    calculateResults();
  }, [revenue, qualityPercentage, prevention, appraisal, internalDefect, externalDefect, lostSales, customerChurn, marketShareLoss, productivityLoss, currency, displayUnit]);

  // Validate percentages
  useEffect(() => {
    const total = prevention + appraisal + internalDefect + externalDefect;
    if (Math.abs(total - 100) > 0.01) {
      setValidationError(t.percentageError);
    } else {
      setValidationError('');
    }
  }, [prevention, appraisal, internalDefect, externalDefect, t.percentageError]);

  const calculateResults = () => {
    const unitFactor = displayUnit === 'MILLION' ? 1000000 : 1000000000;
    const revenueInUnit = revenue * unitFactor;
    const totalQualityCost = (revenueInUnit * qualityPercentage) / 100;
    
    const preventionCost = (totalQualityCost * prevention) / 100;
    const appraisalCost = (totalQualityCost * appraisal) / 100;
    const internalDefectCost = (totalQualityCost * internalDefect) / 100;
    const externalDefectCost = (totalQualityCost * externalDefect) / 100;
    
    // Good Quality Costs (Prevention + Appraisal)
    const goodQualityCost = preventionCost + appraisalCost;
    
    // Poor Quality Costs (Internal + External Defects)
    const poorQualityCost = internalDefectCost + externalDefectCost;
    
    let opportunityCostTotal = 0;
    if (opportunityCosts) {
      const lostSalesCost = (revenueInUnit * lostSales) / 100;
      const customerChurnCost = (revenueInUnit * customerChurn) / 100;
      const marketShareCost = (revenueInUnit * marketShareLoss) / 100;
      const productivityCost = (revenueInUnit * productivityLoss) / 100;
      opportunityCostTotal = lostSalesCost + customerChurnCost + marketShareCost + productivityCost;
    }
    
    const totalImpact = totalQualityCost + opportunityCostTotal;
    
    setResults({
      totalQualityCost,
      preventionCost,
      appraisalCost,
      internalDefectCost,
      externalDefectCost,
      goodQualityCost,
      poorQualityCost,
      opportunityCostTotal,
      totalImpact,
      revenuePercentage: (totalImpact / revenueInUnit) * 100
    });
  };

  const formatCurrency = (value) => {
    const unitFactor = displayUnit === 'MILLION' ? 1000000 : 1000000000;
    const unitSuffix = displayUnit === 'MILLION' ? 'M' : 'B';
    const currencySymbol = currency === 'EUR' ? '€' : currency === 'USD' ? '$' : currency === 'GBP' ? '£' : '¥';
    const formattedValue = (value / unitFactor).toFixed(2);
    return `${currencySymbol}${formattedValue}${unitSuffix}`;
  };

  // Simple chart components
  const SimpleBarChart = ({ data, title }) => (
    <div className="w-full">
      <h4 className="text-md font-medium text-gray-700 mb-4 text-center">{title}</h4>
      <div className="space-y-3">
        {data.map((item, index) => (
          <div key={index} className="flex items-center space-x-3">
            <div className="w-24 text-sm text-gray-600 truncate">{item.name}</div>
            <div className="flex-1 bg-gray-200 rounded-full h-6 relative">
              <div 
                className="h-6 rounded-full flex items-center justify-end pr-2"
                style={{ 
                  width: `${Math.min(100, (item.value / Math.max(...data.map(d => d.value))) * 100)}%`,
                  backgroundColor: item.color 
                }}
              >
                <span className="text-white text-xs font-medium">
                  {formatCurrency(item.value)}
                </span>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  const SimplePieChart = ({ data, title }) => {
    const total = data.reduce((sum, item) => sum + item.value, 0);
    return (
      <div className="w-full">
        <h4 className="text-md font-medium text-gray-700 mb-4 text-center">{title}</h4>
        <div className="relative w-48 h-48 mx-auto mb-4">
          <svg viewBox="0 0 100 100" className="w-full h-full transform -rotate-90">
            {data.map((item, index) => {
              const percentage = (item.value / total) * 100;
              const angle = (percentage / 100) * 360;
              const prevPercentage = data.slice(0, index).reduce((sum, d) => sum + d.value, 0) / total * 100;
              const prevAngle = (prevPercentage / 100) * 360;
              
              const x1 = 50 + 35 * Math.cos((prevAngle - 90) * Math.PI / 180);
              const y1 = 50 + 35 * Math.sin((prevAngle - 90) * Math.PI / 180);
              const x2 = 50 + 35 * Math.cos((prevAngle + angle - 90) * Math.PI / 180);
              const y2 = 50 + 35 * Math.sin((prevAngle + angle - 90) * Math.PI / 180);
              
              const largeArc = angle > 180 ? 1 : 0;
              
              return (
                <path
                  key={index}
                  d={`M 50 50 L ${x1} ${y1} A 35 35 0 ${largeArc} 1 ${x2} ${y2} Z`}
                  fill={item.color}
                  stroke="white"
                  strokeWidth="0.5"
                />
              );
            })}
          </svg>
        </div>
        <div className="grid grid-cols-2 gap-2 text-sm">
          {data.map((item, index) => (
            <div key={index} className="flex items-center space-x-2">
              <div 
                className="w-3 h-3 rounded-full" 
                style={{ backgroundColor: item.color }}
              />
              <span className="text-gray-600">{item.name}: {item.value.toFixed(1)}%</span>
            </div>
          ))}
        </div>
      </div>
    );
  };

  // Chart data
  const barChartData = opportunityCosts ? [
    // Quality Costs
    { name: t.prevention, value: results.preventionCost || 0, color: '#3b82f6' },
    { name: t.appraisal, value: results.appraisalCost || 0, color: '#10b981' },
    { name: t.internalDefect, value: results.internalDefectCost || 0, color: '#f59e0b' },
    { name: t.externalDefect, value: results.externalDefectCost || 0, color: '#ef4444' },
    // Opportunity Costs
    { name: t.lostSales, value: (revenue * (displayUnit === 'MILLION' ? 1000000 : 1000000000) * lostSales) / 100 || 0, color: '#8b5cf6' },
    { name: t.customerChurn, value: (revenue * (displayUnit === 'MILLION' ? 1000000 : 1000000000) * customerChurn) / 100 || 0, color: '#f97316' },
    { name: t.marketShareLoss, value: (revenue * (displayUnit === 'MILLION' ? 1000000 : 1000000000) * marketShareLoss) / 100 || 0, color: '#06b6d4' },
    { name: t.productivityLoss, value: (revenue * (displayUnit === 'MILLION' ? 1000000 : 1000000000) * productivityLoss) / 100 || 0, color: '#84cc16' }
  ] : [
    { name: t.prevention, value: results.preventionCost || 0, color: '#3b82f6' },
    { name: t.appraisal, value: results.appraisalCost || 0, color: '#10b981' },
    { name: t.internalDefect, value: results.internalDefectCost || 0, color: '#f59e0b' },
    { name: t.externalDefect, value: results.externalDefectCost || 0, color: '#ef4444' }
  ];

  const pieChartData = opportunityCosts ? [
    // Quality Cost Percentages (scaled down proportionally)
    { name: t.prevention, value: prevention * (qualityPercentage / 100), color: '#3b82f6' },
    { name: t.appraisal, value: appraisal * (qualityPercentage / 100), color: '#10b981' },
    { name: t.internalDefect, value: internalDefect * (qualityPercentage / 100), color: '#f59e0b' },
    { name: t.externalDefect, value: externalDefect * (qualityPercentage / 100), color: '#ef4444' },
    // Opportunity Cost Percentages
    { name: t.lostSales, value: lostSales, color: '#8b5cf6' },
    { name: t.customerChurn, value: customerChurn, color: '#f97316' },
    { name: t.marketShareLoss, value: marketShareLoss, color: '#06b6d4' },
    { name: t.productivityLoss, value: productivityLoss, color: '#84cc16' }
  ] : [
    { name: t.prevention, value: prevention, color: '#3b82f6' },
    { name: t.appraisal, value: appraisal, color: '#10b981' },
    { name: t.internalDefect, value: internalDefect, color: '#f59e0b' },
    { name: t.externalDefect, value: externalDefect, color: '#ef4444' }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-blue-50">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-600 via-blue-700 to-blue-800 text-white shadow-xl">
        <div className="max-w-7xl mx-auto px-4 py-8">
          <div className="flex items-center justify-between flex-wrap gap-4">
            <div className="flex items-center space-x-4">
              <div className="w-10 h-10 bg-blue-500 rounded-lg flex items-center justify-center text-2xl">
                📊
              </div>
              <div>
                <h1 className="text-3xl font-bold">{t.title}</h1>
                <p className="text-blue-100 mt-1">{t.subtitle}</p>
              </div>
            </div>
            <div className="flex items-center space-x-4">
              <button className="flex items-center space-x-2 bg-blue-500 hover:bg-blue-400 px-4 py-2 rounded-lg transition-colors">
                <span>💾</span> <span>{t.save}</span>
              </button>
              <button className="flex items-center space-x-2 bg-green-500 hover:bg-green-400 px-4 py-2 rounded-lg transition-colors">
                <span>📥</span> <span>{t.export}</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 py-8">
        {/* Controls */}
        <div className="bg-white rounded-xl shadow-lg p-6 mb-8">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                🌍 {t.language}
              </label>
              <select 
                value={language} 
                onChange={(e) => setLanguage(e.target.value)}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="EN">English</option>
                <option value="DE">Deutsch</option>
                <option value="FR">Français</option>
                <option value="ES">Español</option>
                <option value="ZH">中文</option>
              </select>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                💱 {t.currency}
              </label>
              <select 
                value={currency} 
                onChange={(e) => setCurrency(e.target.value)}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="EUR">Euro (€)</option>
                <option value="USD">US Dollar ($)</option>
                <option value="GBP">British Pound (£)</option>
                <option value="CNY">Chinese Yuan (¥)</option>
              </select>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                📈 {t.unit}
              </label>
              <select 
                value={displayUnit} 
                onChange={(e) => setDisplayUnit(e.target.value)}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="MILLION">Millions</option>
                <option value="BILLION">Billions</option>
              </select>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                ⚙️ {t.enableOpportunity}
              </label>
              <button
                onClick={() => setOpportunityCosts(!opportunityCosts)}
                className={`w-full p-3 rounded-lg border-2 transition-all ${
                  opportunityCosts 
                    ? 'bg-blue-500 text-white border-blue-500' 
                    : 'bg-gray-100 text-gray-700 border-gray-300 hover:bg-gray-200'
                }`}
              >
                <span>{opportunityCosts ? '👁️' : '🙈'}</span> {opportunityCosts ? 'Enabled' : 'Disabled'}
              </button>
            </div>
          </div>
        </div>

        {/* Main Content Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* Input Section */}
          <div className="space-y-6">
            {/* Basic Parameters */}
            <div className="bg-white rounded-xl shadow-lg p-6">
              <h3 className="text-lg font-semibold text-gray-800 mb-4 border-b border-gray-200 pb-2">
                Input Parameters
              </h3>
              
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    {t.revenue} ({currency} {displayUnit === 'MILLION' ? 'Millions' : 'Billions'})
                  </label>
                  <input
                    type="number"
                    value={revenue}
                    onChange={(e) => setRevenue(Number(e.target.value))}
                    className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="140"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    {t.qualityBasis}
                  </label>
                  <input
                    type="number"
                    value={qualityPercentage}
                    onChange={(e) => setQualityPercentage(Number(e.target.value))}
                    className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="6"
                    min="0"
                    max="100"
                    step="0.1"
                  />
                </div>
              </div>
            </div>

            {/* Cost Distribution */}
            <div className="bg-white rounded-xl shadow-lg p-6">
              <h3 className="text-lg font-semibold text-gray-800 mb-4 border-b border-gray-200 pb-2">
                {t.costDistribution}
              </h3>
              
              {validationError && (
                <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded-lg flex items-center">
                  <span className="text-red-500 mr-2">⚠️</span>
                  <span className="text-red-700 text-sm">{validationError}</span>
                </div>
              )}
              
              {!validationError && (
                <div className="mb-4 p-3 bg-green-50 border border-green-200 rounded-lg flex items-center">
                  <span className="text-green-500 mr-2">✅</span>
                  <span className="text-green-700 text-sm">All values are valid</span>
                </div>
              )}
              
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-2" style={{color: '#3b82f6'}}>
                    {t.prevention}
                  </label>
                  <input
                    type="number"
                    value={prevention}
                    onChange={(e) => setPrevention(Number(e.target.value))}
                    className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    min="0"
                    max="100"
                    step="0.1"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium mb-2" style={{color: '#10b981'}}>
                    {t.appraisal}
                  </label>
                  <input
                    type="number"
                    value={appraisal}
                    onChange={(e) => setAppraisal(Number(e.target.value))}
                    className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    min="0"
                    max="100"
                    step="0.1"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium mb-2" style={{color: '#f59e0b'}}>
                    {t.internalDefect}
                  </label>
                  <input
                    type="number"
                    value={internalDefect}
                    onChange={(e) => setInternalDefect(Number(e.target.value))}
                    className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    min="0"
                    max="100"
                    step="0.1"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium mb-2" style={{color: '#ef4444'}}>
                    {t.externalDefect}
                  </label>
                  <input
                    type="number"
                    value={externalDefect}
                    onChange={(e) => setExternalDefect(Number(e.target.value))}
                    className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    min="0"
                    max="100"
                    step="0.1"
                  />
                </div>
              </div>
              
              <div className="mt-4 p-3 bg-gray-50 rounded-lg">
                <div className="text-center">
                  <span className="text-sm text-gray-600">Total: </span>
                  <span className={`font-semibold ${Math.abs((prevention + appraisal + internalDefect + externalDefect) - 100) < 0.01 ? 'text-green-600' : 'text-red-600'}`}>
                    {(prevention + appraisal + internalDefect + externalDefect).toFixed(1)}%
                  </span>
                </div>
              </div>
            </div>

            {/* Opportunity Costs */}
            {opportunityCosts && (
              <div className="bg-white rounded-xl shadow-lg p-6">
                <h3 className="text-lg font-semibold text-gray-800 mb-4 border-b border-gray-200 pb-2">
                  {t.opportunityFactors}
                </h3>
                
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      {t.lostSales}
                    </label>
                    <input
                      type="number"
                      value={lostSales}
                      onChange={(e) => setLostSales(Number(e.target.value))}
                      className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      min="0"
                      max="100"
                      step="0.1"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      {t.customerChurn}
                    </label>
                    <input
                      type="number"
                      value={customerChurn}
                      onChange={(e) => setCustomerChurn(Number(e.target.value))}
                      className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      min="0"
                      max="100"
                      step="0.1"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      {t.marketShareLoss}
                    </label>
                    <input
                      type="number"
                      value={marketShareLoss}
                      onChange={(e) => setMarketShareLoss(Number(e.target.value))}
                      className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      min="0"
                      max="100"
                      step="0.1"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      {t.productivityLoss}
                    </label>
                    <input
                      type="number"
                      value={productivityLoss}
                      onChange={(e) => setProductivityLoss(Number(e.target.value))}
                      className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      min="0"
                      max="100"
                      step="0.1"
                    />
                  </div>
                </div>
              </div>
            )}
          </div>

          {/* Results Section */}
          <div className="space-y-6">
            {/* Results Cards */}
            <div className="bg-white rounded-xl shadow-lg p-6">
              <h3 className="text-lg font-semibold text-gray-800 mb-4 border-b border-gray-200 pb-2">
                {t.results}
              </h3>
              
              <div className="space-y-4">
                {/* Cost of Good Quality */}
                <div className="bg-green-50 border border-green-200 rounded-lg p-4">
                  <div className="flex justify-between items-center">
                    <span className="font-medium text-green-800">{t.costOfGoodQuality}</span>
                    <span className="text-xl font-bold text-green-600">
                      {formatCurrency(results.goodQualityCost || 0)}
                    </span>
                  </div>
                  <div className="text-sm text-green-600 mt-1">
                    Prevention + Appraisal: {((prevention + appraisal)).toFixed(1)}%
                  </div>
                </div>

                {/* Cost of Poor Quality */}
                <div className="bg-red-50 border border-red-200 rounded-lg p-4">
                  <div className="flex justify-between items-center">
                    <span className="font-medium text-red-800">{t.costOfPoorQuality}</span>
                    <span className="text-xl font-bold text-red-600">
                      {formatCurrency(results.poorQualityCost || 0)}
                    </span>
                  </div>
                  <div className="text-sm text-red-600 mt-1">
                    Internal + External Failures: {((internalDefect + externalDefect)).toFixed(1)}%
                  </div>
                </div>

                {/* Individual Cost Categories */}
                <div className="grid grid-cols-2 gap-3">
                  <div className="bg-blue-50 border border-blue-200 rounded-lg p-3">
                    <div className="text-sm text-blue-600">{t.prevention}</div>
                    <div className="font-semibold text-blue-800">
                      {formatCurrency(results.preventionCost || 0)}
                    </div>
                  </div>
                  
                  <div className="bg-emerald-50 border border-emerald-200 rounded-lg p-3">
                    <div className="text-sm text-emerald-600">{t.appraisal}</div>
                    <div className="font-semibold text-emerald-800">
                      {formatCurrency(results.appraisalCost || 0)}
                    </div>
                  </div>
                  
                  <div className="bg-amber-50 border border-amber-200 rounded-lg p-3">
                    <div className="text-sm text-amber-600">{t.internalDefect}</div>
                    <div className="font-semibold text-amber-800">
                      {formatCurrency(results.internalDefectCost || 0)}
                    </div>
                  </div>
                  
                  <div className="bg-red-50 border border-red-200 rounded-lg p-3">
                    <div className="text-sm text-red-600">{t.externalDefect}</div>
                    <div className="font-semibold text-red-800">
                      {formatCurrency(results.externalDefectCost || 0)}
                    </div>
                  </div>
                </div>

                {/* Total Quality Cost */}
                <div className="bg-gray-50 border border-gray-200 rounded-lg p-4">
                  <div className="flex justify-between items-center">
                    <span className="font-medium text-gray-800">{t.totalQualityCost}</span>
                    <span className="text-xl font-bold text-gray-900">
                      {formatCurrency(results.totalQualityCost || 0)}
                    </span>
                  </div>
                </div>

                {/* Opportunity Costs (if enabled) */}
                {opportunityCosts && (
                  <>
                    <div className="bg-purple-50 border border-purple-200 rounded-lg p-4">
                      <div className="flex justify-between items-center">
                        <span className="font-medium text-purple-800">{t.totalOpportunityCost}</span>
                        <span className="text-xl font-bold text-purple-600">
                          {formatCurrency(results.opportunityCostTotal || 0)}
                        </span>
                      </div>
                    </div>

                    {/* Individual Opportunity Cost Categories */}
                    <div className="grid grid-cols-2 gap-3">
                      <div className="bg-purple-50 border border-purple-200 rounded-lg p-3">
                        <div className="text-sm text-purple-600">{t.lostSales}</div>
                        <div className="font-semibold text-purple-800">
                          {formatCurrency((revenue * (displayUnit === 'MILLION' ? 1000000 : 1000000000) * lostSales) / 100)}
                        </div>
                      </div>
                      
                      <div className="bg-orange-50 border border-orange-200 rounded-lg p-3">
                        <div className="text-sm text-orange-600">{t.customerChurn}</div>
                        <div className="font-semibold text-orange-800">
                          {formatCurrency((revenue * (displayUnit === 'MILLION' ? 1000000 : 1000000000) * customerChurn) / 100)}
                        </div>
                      </div>
                      
                      <div className="bg-cyan-50 border border-cyan-200 rounded-lg p-3">
                        <div className="text-sm text-cyan-600">{t.marketShareLoss}</div>
                        <div className="font-semibold text-cyan-800">
                          {formatCurrency((revenue * (displayUnit === 'MILLION' ? 1000000 : 1000000000) * marketShareLoss) / 100)}
                        </div>
                      </div>
                      
                      <div className="bg-lime-50 border border-lime-200 rounded-lg p-3">
                        <div className="text-sm text-lime-600">{t.productivityLoss}</div>
                        <div className="font-semibold text-lime-800">
                          {formatCurrency((revenue * (displayUnit === 'MILLION' ? 1000000 : 1000000000) * productivityLoss) / 100)}
                        </div>
                      </div>
                    </div>

                    <div className="bg-gradient-to-r from-blue-500 to-purple-600 text-white rounded-lg p-4">
                      <div className="flex justify-between items-center">
                        <span className="font-medium">{t.totalImpact}</span>
                        <span className="text-2xl font-bold">
                          {formatCurrency(results.totalImpact || 0)}
                        </span>
                      </div>
                      <div className="text-sm opacity-90 mt-1">
                        {(results.revenuePercentage || 0).toFixed(1)}% of Revenue
                      </div>
                    </div>
                  </>
                )}
              </div>
            </div>
          </div>
        </div>

        {/* Charts Section */}
        <div className="mt-8 bg-white rounded-xl shadow-lg p-6">
          <h3 className="text-lg font-semibold text-gray-800 mb-6 text-center">
            Quality Cost Visualization
            {opportunityCosts && (
              <span className="block text-sm font-normal text-gray-600 mt-1">
                Including Opportunity Costs Analysis
              </span>
            )}
          </h3>
          
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            {/* Bar Chart */}
            <SimpleBarChart 
              data={barChartData} 
              title={opportunityCosts ? "Total Impact Values" : "Quality Cost Values"} 
            />

            {/* Pie Chart */}
            <SimplePieChart 
              data={pieChartData} 
              title={opportunityCosts ? "Total Cost Distribution" : "Quality Cost Distribution"} 
            />
          </div>
          
          {opportunityCosts && (
            <div className="mt-6 p-4 bg-gradient-to-r from-purple-50 to-blue-50 rounded-lg">
              <div className="flex items-center justify-center space-x-4 text-sm">
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 rounded-full bg-blue-500"></div>
                  <span className="text-gray-600">Quality Costs</span>
                </div>
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 rounded-full bg-purple-500"></div>
                  <span className="text-gray-600">Opportunity Costs</span>
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Quality Insights Section */}
        <div className="mt-8 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl p-6">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">Quality Cost Insights</h3>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-white rounded-lg p-4 shadow-sm">
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm font-medium text-gray-600">Good vs Poor Quality Ratio</span>
                <span className="text-blue-500 text-xl">📈</span>
              </div>
              <div className="text-2xl font-bold text-gray-900">
                {results.goodQualityCost && results.poorQualityCost 
                  ? (results.goodQualityCost / results.poorQualityCost).toFixed(2)
                  : '0.00'
                }:1
              </div>
              <div className="text-xs text-gray-500 mt-1">
                {results.goodQualityCost > results.poorQualityCost 
                  ? 'Investment-focused approach ✓' 
                  : 'Reactive approach - consider more prevention'
                }
              </div>
            </div>

            <div className="bg-white rounded-lg p-4 shadow-sm">
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm font-medium text-gray-600">Quality Impact on Revenue</span>
                <span className="text-green-500 text-xl">💰</span>
              </div>
              <div className="text-2xl font-bold text-gray-900">
                {(results.revenuePercentage || 0).toFixed(1)}%
              </div>
              <div className="text-xs text-gray-500 mt-1">
                {results.revenuePercentage > 10 
                  ? 'High impact - optimization needed' 
                  : results.revenuePercentage > 5 
                  ? 'Moderate impact - monitor closely'
                  : 'Low impact - well controlled'
                }
              </div>
            </div>

            <div className="bg-white rounded-lg p-4 shadow-sm">
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm font-medium text-gray-600">Cost Balance Score</span>
                <span className="text-purple-500 text-xl">⚙️</span>
              </div>
              <div className="text-2xl font-bold text-gray-900">
                {validationError ? 'N/A' : 
                  Math.round(100 - Math.abs(50 - (prevention + appraisal)))
                }
              </div>
              <div className="text-xs text-gray-500 mt-1">
                {(prevention + appraisal) >= 40 && (prevention + appraisal) <= 60
                  ? 'Optimal prevention focus ✓'
                  : (prevention + appraisal) < 40
                  ? 'Consider more prevention investment'
                  : 'High prevention - ensure ROI'
                }
              </div>
            </div>
          </div>

          {/* Recommendations */}
          <div className="mt-6 p-4 bg-white rounded-lg shadow-sm">
            <h4 className="font-medium text-gray-800 mb-3 flex items-center">
              <span className="mr-2">⚠️</span> Recommendations
            </h4>
            <div className="space-y-2 text-sm text-gray-600">
              {(prevention + appraisal) < 40 && (
                <div className="flex items-start space-x-2">
                  <span className="text-yellow-500">•</span>
                  <span>Consider increasing prevention and appraisal costs to reduce failure costs long-term</span>
                </div>
              )}
              {externalDefect > internalDefect && (
                <div className="flex items-start space-x-2">
                  <span className="text-red-500">•</span>
                  <span>High external failure costs indicate quality issues reaching customers - strengthen internal controls</span>
                </div>
              )}
              {results.revenuePercentage > 8 && (
                <div className="flex items-start space-x-2">
                  <span className="text-orange-500">•</span>
                  <span>Quality costs exceed 8% of revenue - implement comprehensive quality improvement program</span>
                </div>
              )}
              {(prevention + appraisal) >= 40 && (prevention + appraisal) <= 60 && (internalDefect + externalDefect) <= 40 && (
                <div className="flex items-start space-x-2">
                  <span className="text-green-500">•</span>
                  <span>Good balance between prevention and failure costs - maintain current strategy</span>
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Session Info (for anonymous users) */}
        <div className="mt-8 bg-yellow-50 border border-yellow-200 rounded-lg p-4">
          <div className="flex items-start space-x-3">
            <span className="text-yellow-600 mt-0.5 text-xl">⚠️</span>
            <div>
              <h4 className="font-medium text-yellow-800">Anonymous Session</h4>
              <p className="text-sm text-yellow-700 mt-1">
                You're using the calculator anonymously. Your data is temporarily stored for this session. 
                <button className="underline hover:no-underline ml-1 font-medium">
                  Sign in to save your calculations permanently.
                </button>
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Footer */}
      <footer className="bg-gray-800 text-white mt-12">
        <div className="max-w-7xl mx-auto px-4 py-8">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div>
              <h5 className="font-semibold mb-3">Quality Cost Calculator</h5>
              <p className="text-gray-300 text-sm">
                Comprehensive tool for analyzing quality costs and optimizing quality management strategies.
              </p>
            </div>
            <div>
              <h5 className="font-semibold mb-3">Features</h5>
              <ul className="text-gray-300 text-sm space-y-1">
                <li>• Real-time calculations</li>
                <li>• Multi-currency support</li>
                <li>• Opportunity cost analysis</li>
                <li>• Interactive visualizations</li>
                <li>• Export capabilities</li>
              </ul>
            </div>
            <div>
              <h5 className="font-semibold mb-3">Support</h5>
              <ul className="text-gray-300 text-sm space-y-1">
                <li>• Documentation</li>
                <li>• User Guide</li>
                <li>• API Reference</li>
                <li>• Contact Support</li>
              </ul>
            </div>
          </div>
          <div className="border-t border-gray-700 mt-8 pt-4 text-center text-gray-400 text-sm">
            © 2025 Quality Cost Calculator. Built with Oracle APEX and modern web technologies.
          </div>
        </div>
      </footer>
    </div>
  );
};

export default QualityCostCalculator;