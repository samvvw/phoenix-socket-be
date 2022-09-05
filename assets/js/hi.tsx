import React, { useEffect, useRef, useState } from 'react'
import { Socket, Channel, Presence } from 'phoenix'

declare global {
    interface Window {
        userToken: string
    }
}

interface GreeterProps {
    name: string
}
interface User {
    id: string
}

const Greeter: React.FC<GreeterProps> = (props: GreeterProps) => {
    const [out, setOut] = useState('')
    const [user, setUser] = useState(null)
    const [roomUsers, setRoomUsers] = useState<User[]>([])
    const [presences, setPresences] = useState([])
    const name = props.name
    const UserSocket = new Socket('/socket', {
        params: { token: window.userToken, user_id: '1' },
    })
    const pingRef = useRef(null)

    const channel = useRef<Channel | null>(null)
    const presence = useRef<Presence | null>(null)

    const handleJoinRoom = (e) => {
        e.preventDefault()
        if (!user) {
            setUser(e.target.elements['user-name'].value)
        }
    }

    const handleLeaveRoom = (e) => {
        e.preventDefault()
        setUser(null)
        setRoomUsers([])
        setPresences([])
        if (channel.current) {
            channel.current.leave()
        }
    }

    useEffect(() => {
        if (user) {
            console.log('useEffect')

            UserSocket.connect()

            channel.current = UserSocket.channel('topic:subtopic', { user })

            presence.current = new Presence(channel.current)

            channel.current.on('presence_diff', (diff) => {
                const { joins, leaves } = diff

                console.log(
                    '[presence_diff] -> joins',
                    Object.getOwnPropertyNames(joins)
                )

                console.log(
                    '[presence_diff] -> leaves',
                    Object.getOwnPropertyNames(leaves)
                )

                Object.getOwnPropertyNames(joins).forEach((k) => {
                    const toast = document.createElement('div')
                    toast.innerHTML = `${k} joined`
                    window.document.body.appendChild(toast)
                    setTimeout(() => {
                        window.document.body.removeChild(toast)
                    }, 3000)
                })

                Object.getOwnPropertyNames(leaves).forEach((k) => {
                    console.log('leave', k)
                    const toast = document.createElement('div')
                    toast.innerHTML = `${k} has left`
                    window.document.body.appendChild(toast)
                    setTimeout(() => {
                        window.document.body.removeChild(toast)
                    }, 3000)
                })
            })

            presence.current.onSync(() => {
                setPresences(
                    presence.current.list((id, { metas: [first, ...rest] }) => {
                        first.id = id
                        first.count = rest.length
                        return first
                    })
                )
            })

            channel.current
                .join()
                .receive('ok', () => {
                    console.log('Joined successfully')
                })
                .receive('error', (reason) => {
                    console.log('Failed to join', reason)
                })

            channel.current.on('pong', (msg) => {
                console.log('pong')
                console.log(msg)
                setOut('pong')
                setTimeout(() => {}, 500)
                console.log(
                    presence.current.list((id, { metas: [first, ...rest] }) => {
                        first.count = rest.length + 1 // count of this user's presences
                        first.id = id
                        return first
                    })
                )
            })

            return () => {
                UserSocket.disconnect()
                channel.current?.leave()
            }
        }
    }, [user])

    const handlePing = () => {
        console.log('ping')
        channel.current?.push('ping', {})
        setOut('ping')
        console.log('_Ping_ref', pingRef.current)
    }

    return (
        <section className="phx-hero">
            {!user ? (
                <form action="submit" onSubmit={handleJoinRoom}>
                    <div className="form-field-wrapper">
                        <label htmlFor="user-name">User name:</label>
                        <input
                            type="text"
                            id="user-name"
                            placeholder="Enter your user name"
                        />
                    </div>
                    <button>
                        <span>Join</span>
                    </button>
                </form>
            ) : (
                <div>
                    <button onClick={handleLeaveRoom}>Leave Room</button>
                </div>
            )}
            <h1>Hello {name}</h1>
            <button onClick={handlePing}>Ping</button>
            <div>{out ? out : ''}</div>

            <div ref={pingRef}>PINGGGGGJ</div>

            <h2>Online</h2>
            {presences.map((presence: { id: string; count: number }) => {
                return (
                    <div key={presence.id}>
                        {presence.id} - {presence.count}
                    </div>
                )
            })}
            <ul>
                {roomUsers.map((user) => (
                    <li key={user.id}>{user.id}</li>
                ))}
            </ul>
        </section>
    )
}
export function logger(log: string) {
    console.log('[Log] ', log)
}

export default Greeter
