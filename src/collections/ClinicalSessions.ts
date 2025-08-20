import { CollectionConfig } from 'payload'

export const ClinicalSessions: CollectionConfig = {
  slug: 'clinical-sessions',
  labels: {
    singular: 'Sesión Clínica',
    plural: 'Sesiones Clínicas',
  },
  fields: [
    {
      name: 'patient',
      type: 'relationship',
      relationTo: 'users', // Usando la colección de usuarios existente
      required: true,
      label: 'Paciente',
    },
    {
      name: 'date',
      type: 'date',
      required: true,
      label: 'Fecha de la sesión',
    },
    {
      name: 'consultationReason',
      type: 'textarea',
      label: 'Motivo de la consulta',
    },
    // Lesiones elementales
    {
      name: 'elementaryLesions',
      type: 'group',
      label: 'Lesiones Elementales',
      fields: [
        {
          name: 'closedComedones',
          type: 'checkbox',
          label: 'Comedones cerrados',
          defaultValue: false,
        },
        {
          name: 'openComedones',
          type: 'checkbox',
          label: 'Comedones abiertos',
          defaultValue: false,
        },
        {
          name: 'papules',
          type: 'checkbox',
          label: 'Pápulas',
          defaultValue: false,
        },
        {
          name: 'pustules',
          type: 'checkbox',
          label: 'Pústulas',
          defaultValue: false,
        },
        {
          name: 'nodules',
          type: 'checkbox',
          label: 'Nódulos',
          defaultValue: false,
        },
        {
          name: 'tubercles',
          type: 'checkbox',
          label: 'Tubérculos',
          defaultValue: false,
        },
        {
          name: 'scars',
          type: 'checkbox',
          label: 'Cicatrices',
          defaultValue: false,
        },
        {
          name: 'excoriations',
          type: 'checkbox',
          label: 'Escoriaciones',
          defaultValue: false,
        },
        {
          name: 'miliumCysts',
          type: 'checkbox',
          label: 'Quistes de milium',
          defaultValue: false,
        },
        {
          name: 'sebaceousCysts',
          type: 'checkbox',
          label: 'Quistes sebáceos',
          defaultValue: false,
        },
        {
          name: 'macules',
          type: 'checkbox',
          label: 'Máculas',
          defaultValue: false,
        },
      ],
    },
    // Diagnósticos y objetivos
    {
      name: 'diagnosis',
      type: 'textarea',
      label: 'Diagnóstico',
    },
    {
      name: 'goals',
      type: 'textarea',
      label: 'Objetivos',
    },
    // Protocolo aplicado
    {
      name: 'appliedProtocol',
      type: 'group',
      label: 'Protocolo Aplicado',
      fields: [
        {
          name: 'cleaning',
          type: 'textarea',
          label: 'Limpieza',
        },
        {
          name: 'returnToEudermia',
          type: 'textarea',
          label: 'Retorno a la eudermia',
        },
        {
          name: 'exfoliation',
          type: 'textarea',
          label: 'Exfoliación',
        },
        {
          name: 'asepsis',
          type: 'textarea',
          label: 'Asepsia',
        },
        {
          name: 'extractions',
          type: 'textarea',
          label: 'Extracciones',
        },
        {
          name: 'pa',
          type: 'textarea',
          label: 'P.A.',
        },
        {
          name: 'massages',
          type: 'textarea',
          label: 'Masajes',
        },
        {
          name: 'mask',
          type: 'textarea',
          label: 'Máscara',
        },
        {
          name: 'finalProduct',
          type: 'textarea',
          label: 'Producto final',
        },
        {
          name: 'sunscreen',
          type: 'textarea',
          label: 'Protector solar',
        },
        {
          name: 'appliedApparatus',
          type: 'textarea',
          label: 'Aparatología aplicada',
        },
        {
          name: 'homeCareDay',
          type: 'textarea',
          label: 'Apoyo domiciliario DÍA',
        },
        {
          name: 'homeCareNight',
          type: 'textarea',
          label: 'Apoyo domiciliario NOCHE',
        },
      ],
    },
  ],
  admin: {
    useAsTitle: 'date',
    defaultColumns: ['date', 'patient', 'diagnosis'],
    group: 'Clínica',
  },
  access: {
    read: () => true,
    create: () => true,
    update: () => true,
    delete: () => true,
  },
  timestamps: true,
}