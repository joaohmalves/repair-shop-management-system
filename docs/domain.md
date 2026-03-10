# Domain Overview | Visão Geral do Domínio

🇺🇸 English

🇧🇷 Português


# 🇺🇸 English Version

## Overview

This document describes the core business domain of the **Repair Shop Management System**.

The purpose of this system is to help repair shops manage customers, devices, technicians, service orders and payments.

The goal is to model the business domain clearly so that both developers and business stakeholders share the same understanding of the system.

---

## Ubiquitous Language

The following concepts define the shared language used throughout the system.

### Customer

Represents a client of the repair shop.

A customer can own multiple devices that may require repair services.

Attributes:

- id
- name
- phone
- email
- created_at

---

### Device

Represents an electronic device owned by a customer.

Examples:

- smartphone
- laptop
- tablet

A device belongs to one customer but may have multiple service orders over time.

Attributes:

- id
- customer_id
- brand
- model
- serial_number

---

### Technician

Represents a professional responsible for performing repair services.

A technician may work on multiple service orders depending on their specialization.

Attributes:

- id
- name
- specialization
- created_at

---

### Service Order

Represents a repair request created for a device.

A service order may involve multiple technicians and multiple repair services.

Possible statuses:

- OPEN
- IN_PROGRESS
- WAITING_PART
- COMPLETED
- CANCELLED

Attributes:

- id
- device_id
- status
- description
- created_at

---

### Payment

Represents a payment made for a service order.

Payments may be partial or full depending on the business rules.

Attributes:

- id
- service_order_id
- amount
- payment_method
- created_at

---

## Business Rules

The system follows the rules below:

- A customer can own multiple devices.
- A device belongs to exactly one customer.
- A device can have multiple service orders over time.
- A service order can be assigned to multiple technicians.
- A service order can contain multiple service items.
- Payments can be partial or full.

---

# 🇧🇷 Versão em Português

## Visão Geral

Este documento descreve o domínio de negócio do **Sistema de Gestão de Assistência Técnica**.

O objetivo do sistema é ajudar assistências técnicas a gerenciar clientes, dispositivos, técnicos, ordens de serviço e pagamentos.

A ideia é modelar o domínio do negócio de forma clara para que desenvolvedores e especialistas do negócio compartilhem o mesmo entendimento do sistema.

---

## Linguagem Ubíqua (Ubiquitous Language)

Os conceitos abaixo representam os principais termos utilizados no sistema.

### Customer (Cliente)

Representa um cliente da assistência técnica.

Um cliente pode possuir vários dispositivos que podem precisar de reparo.

Atributos:

- id
- name
- phone
- email
- created_at

---

### Device (Dispositivo)

Representa um dispositivo eletrônico pertencente a um cliente.

Exemplos:

- smartphone
- laptop
- tablet

Um dispositivo pertence a um único cliente, mas pode ter várias ordens de serviço ao longo do tempo.

Atributos:

- id
- customer_id
- brand
- model
- serial_number

---

### Technician (Técnico)

Representa um profissional responsável por executar serviços de reparo.

Um técnico pode trabalhar em várias ordens de serviço dependendo de sua especialização.

Atributos:

- id
- name
- specialization
- created_at

---

### Service Order (Ordem de Serviço)

Representa um pedido de reparo criado para um dispositivo.

Uma ordem de serviço pode envolver múltiplos técnicos e vários serviços de reparo.

Possíveis status:

- OPEN
- IN_PROGRESS
- WAITING_PART
- COMPLETED
- CANCELLED

Atributos:

- id
- device_id
- status
- description
- created_at

---

### Payment (Pagamento)

Representa um pagamento realizado para uma ordem de serviço.

Os pagamentos podem ser parciais ou completos dependendo das regras de negócio.

Atributos:

- id
- service_order_id
- amount
- payment_method
- created_at

---

## Regras de Negócio

O sistema segue as seguintes regras:

- Um cliente pode possuir vários dispositivos.
- Um dispositivo pertence a apenas um cliente.
- Um dispositivo pode ter várias ordens de serviço ao longo do tempo.
- Uma ordem de serviço pode ter vários técnicos associados.
- Uma ordem de serviço pode conter múltiplos serviços realizados.
- Pagamentos podem ser parcelados ou à vista.