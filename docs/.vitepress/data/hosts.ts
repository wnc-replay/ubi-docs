export const environments = {
  PROD: {
    public: 'https://public-ubiservices.ubi.com',
    connect: 'https://connect.ubisoft.com',
    uss: 'https://uss.ecom.ubi.com',
    scs: 'https://scs.ecom.ubi.com',
    ess: 'https://ess.ubi.com',
  },
  CERT2: {
    public: 'https://cert2-public-ubiservices.ubi.com',
    connect: 'https://cert2-connect.ubisoft.com',
    uss: 'https://uss.uat.ecom.ubi.com',
    scs: null,
    ess: 'https://ess.uat.ecom.ubi.com',
  },
  UAT: {
    public: 'https://uat-public-ubiservices.ubi.com',
    connect: 'https://uat-connect.ubisoft.com',
    uss: 'https://uss.uat.ecom.ubi.com',
    scs: null,
    ess: 'https://ess.uat.ecom.ubi.com',
  },
  DEV: {
    public: null,
    connect: 'https://dev-connect.ubisoft.com',
    uss: 'https://uss.uat.ecom.ubi.com',
    scs: null,
    ess: 'https://ess.uat.ecom.ubi.com',
  },
} as const

export const hosts = {
  public: environments.PROD.public,
  connect: environments.PROD.connect,
  avatars: 'https://ubisoft-avatars.akamaized.net',
  cms: 'https://cms-cache.ubisoft.com',
  bugreporter: 'https://prod-api-bugreporter.ubisoft.com',
  ecom: environments.PROD.uss,
  scs: environments.PROD.scs,
  ess: environments.PROD.ess,
} as const

export type HostKey = keyof typeof hosts
