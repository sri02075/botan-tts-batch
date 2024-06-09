variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "manager_email" {
  description = "Manager Email"
  type        = string
  default     = ""
}

variable "manager_name" {
  description = "Manager Name"
  type        = string
  default     = ""
}

variable "manager_phone" {
  description = "Manager Phone"
  type        = string
  default     = ""
}

variable "service_configs_v2" {
  type  = map(object({
    priority = number
    health_check = string
    services = map(object({
      port = optional(number)
      cpu = optional(number, 256)
      memory = optional(number)
      internal = optional(bool, false)
      task = optional(number, 0)
      max = optional(number, 5)
    }))
  }))
  default = {
    apartment: {
      priority: 20,
      health_check: "/apartment/common/health/ping",
      services: {
        admin: { port: 3000 },
        user: { port: 3001 },
        internal: { port: 3002, internal: true },
        device: { port: 3003 },
      }
    },
    audit: {
      priority: 21,
      health_check: "/audit/common/health/ping",
      services: {
        admin: { port: 3000 },
        internal: { port: 3002, internal: true },
      }
    },
    authn: {
      priority: 22,
      health_check: "/authn/common/health/ping",
      services: {
        admin: { port: 3000 },
        internal: { port: 3002, internal: true },
      }
    },
    device: {
      priority: 23,
      health_check: "/device/common/health/ping",
      services: {
        admin: { port: 3000 },
        user: { port: 3001 },
        internal: { port: 3002, internal: true },
        device: { port: 3003 },
        schedule: { cpu: 1024, internal: true, max: 1 },
      }
    },
    pbx: {
      priority: 24,
      health_check: "/pbx/common/health/ping",
      services: {
        admin: { port: 3000 },
        user: { port: 3001 },
        internal: { port: 3002, internal: true },
        device: { port: 3003 },
      }
    },
    reservation: {
      priority: 25,
      health_check: "/reservation/common/health/ping",
      services: {
        admin: { port: 3000 },
        user: { port: 3001 },
        internal: { port: 3002, internal: true },
      }
    },
    user: {
      priority: 26,
      health_check: "/user/common/health/ping",
      services: {
        user: { port: 3001 },
        internal: { port: 3002, internal: true },
      }
    },
    vote: {
      priority: 27,
      health_check: "/vote/common/health/ping",
      services: {
        admin: { port: 3000 },
        user: { port: 3001 },
        internal: { port: 3002, internal: true },
      }
    },
    patrol: {
      priority: 28,
      health_check: "/patrol/common/health/ping",
      services: {
        admin: { port: 3000 },
      }
    },
    paid: {
      priority: 29,
      health_check: "/paid/common/health/ping",
      services: {
        admin: { port: 3000 },
        internal: { port: 3002, internal: true },
      }
    },
    payment: {
      priority: 30,
      health_check: "/verification/common/health/ping.php",
      services: {
        admin: { port: 3000 },
        user: { port: 3001 },
        internal: { port: 3002 },
      }
    },
  }
}