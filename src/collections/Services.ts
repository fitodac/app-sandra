import { CollectionConfig } from 'payload'

export const Services: CollectionConfig = {
  slug: 'services',
  labels: {
    singular: 'Servicio',
    plural: 'Servicios',
  },
  fields: [
    {
      name: 'name',
      type: 'text',
      required: true,
      label: 'Nombre del Servicio',
    },
    {
      name: 'description',
      type: 'richText',
      label: 'Descripción',
      required: true,
    },
    {
      name: 'features',
      type: 'richText',
      label: 'Incluye',
    },
    {
      type: 'row',
      fields: [
        {
          name: 'price',
          type: 'number',
          label: 'Precio',
          required: true,
          min: 0,
        },

        {
          name: 'duration',
          type: 'number',
          label: 'Duración (horas)',
          required: true,
          min: 0.5,
        },
      ],
      admin: {
        className: 'gap-x-10',
      },
    },
  ],
  admin: {
    useAsTitle: 'name',
    defaultColumns: ['name', 'price', 'duration'],
    group: 'Servicios',
  },
  access: {
    read: () => true,
    create: () => true,
    update: () => true,
    delete: () => true,
  },
  timestamps: true,
}
